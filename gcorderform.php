<?php
/**
 * GcOrderForm
 *
 * @author    Grégory Chartier <hello@gregorychartier.fr>
 * @copyright 2018 Grégory Chartier (https://www.gregorychartier.fr)
 * @license   Commercial license see license.txt
 * @category  Prestashop
 * @category  Module
 */

header('Access-Control-Allow-Origin: *');

if (!defined('_PS_VERSION_')) {
    exit;
}

class GcOrderForm extends Module
{
    public $of_imgname;
    public $of_img;

    public function __construct()
    {
        $this->name = 'gcorderform';
        $this->tab = 'checkout';
        $this->version = '4.0.8';
        $this->bootstrap = true;
        $this->display = 'view';
        $this->ps_versions_compliancy['min'] = '1.5.0.0';
        $this->module_key = '13b6d239b5ac48d570bce902ed622de9';
        $this->author_address = '0x5cD3FdcEF023E7ebeAb44aA7140c992f668973eB';
        $this->need_instance = 0;
        $this->author = 'Grégory Chartier';
        $this->controllers = array('default');
        $this->is_eu_compatible = 1;

        parent::__construct();

        $this->displayName = $this->l('Order Form');
        $this->description = $this->l('Add an order form which makes your customers order quicker and easier.');

        $this->initialize();
    }

    protected function initialize()
    {
        $this->of_imgname = 'gcorderform';
        if ((Shop::getContext() == Shop::CONTEXT_GROUP || Shop::getContext() == Shop::CONTEXT_SHOP)
            && file_exists(_PS_MODULE_DIR_.$this->name.'/views/img/'.$this->of_imgname.'-g'.$this->context->shop->getContextShopGroupID().'.'
                .Configuration::get('GCOF_IMG_EXT'))) {
            $this->of_imgname .= '-g'.$this->context->shop->getContextShopGroupID();
        }

        if (Shop::getContext() == Shop::CONTEXT_SHOP
            && file_exists(_PS_MODULE_DIR_.$this->name.'/views/img/'.$this->of_imgname.'-s'
                .$this->context->shop->getContextShopID().'.'.Configuration::get('GCOF_IMG_EXT'))) {
            $this->of_imgname .= '-s'.$this->context->shop->getContextShopID();
        }

        $this->of_img = Tools::getMediaServer($this->name)._MODULE_DIR_.$this->name.'/views/img/'.$this->of_imgname
            .'.'.Configuration::get('GCOF_IMG_EXT');
    }

    public function install()
    {
        if (!Configuration::updateValue('GCOF_QUANTITY', 0)
            || !Configuration::updateValue('GCOF_EMPTY', 0)
            || !Configuration::updateValue('GCOF_STOCK', 0)
            || !Configuration::updateValue('GCOF_LEFTCOLUMN', 0)
            || !Configuration::updateValue('GCOF_RIGHTCOLUMN', 0)
            || !Configuration::updateValue('GCOF_IMAGE', 0)
            || !Configuration::updateValue('GCOF_IMG', 0)
            || !Configuration::updateValue('GCOF_LINK', 0)
            || !Configuration::updateValue('GCOF_TEMPLATE', 1)
            || !Configuration::updateValue('GCOF_STOPRATING', 0)
            || !Configuration::updateValue('GCOF_ONLY_STOCK', 1)
            || !Configuration::updateValue('GCOF_THUMBNAIL', '')
            || !Configuration::updateValue('GCOF_BIG_IMAGE', '')
            || !Configuration::updateValue('GCOF_CATEGORY_ON_LOAD', 0)
            || !parent::install()
            || !$this->registerHook('backOfficeHeader')
            || !$this->registerHook('displayLeftColumn')
            || !$this->registerHook('displayHeader')
            || !$this->registerHook('displayCustomerAccount')
            || !$this->createImageType()) {
            return false;
        }

        if (version_compare(_PS_VERSION_, '1.7', '>=')) {
            if (!$this->registerHook('overrideLayoutTemplate')
                || !$this->registerHook('displayBeforeBodyClosingTag')) {
                return false;
            }
        }

        foreach (scandir(_PS_MODULE_DIR_.$this->name.'/views/img/') as $file) {
            if (in_array($file, array('gcorderform.jpg', 'gcorderform.gif', 'gcorderform.png'))) {
                Configuration::updateValue('GCOF_IMG_EXT', Tools::substr($file, strrpos($file, '.') + 1));
            }
        }

        $groups = Group::getGroups($this->context->language->id);
        $list_group = '';
        foreach ($groups as $group) {
            $list_group .= (int)$group['id_group'].'-';
        }
        $list_group = rtrim($list_group, '-');
        Configuration::updateValue('GCOF_GROUPS', $list_group);

        $categories_list = GcOrderForm::getCategoriesInString();
        $list_categories = '';

        foreach ($categories_list as $category_list) {
            $list_categories .= (int)$category_list['id_category'].'-';
        }

        $list_categories = rtrim($list_categories, '-');
        Configuration::updateValue('GCOF_CATEGORIES', $list_categories);

        return true;
    }

    public function uninstall()
    {
        if (!parent::uninstall()
            || !Configuration::deleteByName('GCOF_IMG_EXT')
            || !Configuration::deleteByName('GCOF_QUANTITY')
            || !Configuration::deleteByName('GCOF_EMPTY')
            || !Configuration::deleteByName('GCOF_LEFTCOLUMN')
            || !Configuration::deleteByName('GCOF_RIGHTCOLUMN')
            || !Configuration::deleteByName('GCOF_STOCK')
            || !Configuration::deleteByName('GCOF_LINK')
            || !Configuration::deleteByName('GCOF_IMAGE')
            || !Configuration::deleteByName('GCOF_IMG')
            || !Configuration::deleteByName('GCOF_TEMPLATE')
            || !Configuration::deleteByName('GCOF_CATEGORIES')
            || !Configuration::deleteByName('GCOF_ONLY_STOCK')
            || !Configuration::deleteByName('GCOF_GROUPS')
            || !Configuration::deleteByName('GCOF_STOPRATING')
            || !Configuration::deleteByName('GCOF_BIG_IMAGE')
            || !Configuration::deleteByName('GCOF_CATEGORY_ON_LOAD')
            || !Configuration::deleteByName('GCOF_THUMBNAIL')) 
        {
            return false;
        }

        return true;
    }

    public function createImageType()
    {
        if (!ImageType::typeAlreadyExists(ImageType::getFormatedName('order_form_cat'))) {
            $object = new ImageType();
            $object->name = ImageType::getFormatedName('order_form_cat');
            $object->width = '80';
            $object->height = '80';
            $object->categories = true;
            $object->products = false;
            $object->manufacturers = false;
            $object->suppliers = false;
            $object->scenes = false;
            $object->stores = false;
            if (!$object->add()) {
                return false;
            }
        }

        return true;
    }

    public function getContent()
    {
        $output = $this->postProcess();
        $output .= $this->getRating();
        $output .= $this->renderForm();

        return $output;
    }

    public function getRating()
    {
        $stop_rating = (int)Configuration::get('GCOF_STOPRATING');

        if ($stop_rating != 1) {
            return $this->display(__FILE__, 'views/templates/admin/rating.tpl');
        }
    }

    public function postProcess()
    {
        if (Tools::getIsset('stop_rating')) {
            Configuration::updateValue('GCOF_STOPRATING', 1);
            die;
        }

        $output = '';
        if (Tools::isSubmit('submitAdvConf')) {
            if (isset($_FILES['gcof_img']) && isset($_FILES['gcof_img']['tmp_name']) && !empty($_FILES['gcof_img']['tmp_name'])) {
                if (!ImageManager::isCorrectImageFileExt($_FILES['gcof_img']['name'])) {
                    $output .= $this->displayError($this->l('Error with file extension'));
                } elseif ($_FILES['gcof_img']['size'] > Tools::convertBytes(ini_get('upload_max_filesize'))) {
                    $output .= $this->displayError($this->l('Error with file size'));
                } else {
                    Configuration::updateValue('GCOF_IMG_EXT', Tools::substr($_FILES['gcof_img']['name'], strrpos($_FILES['gcof_img']['name'], '.') + 1));

                    $this->of_imgname = 'gcorderform';
                    if (Shop::getContext() == Shop::CONTEXT_GROUP) {
                        $this->of_imgname = 'gcorderform-g'.(int)$this->context->shop->getContextShopGroupID();
                    } elseif (Shop::getContext() == Shop::CONTEXT_SHOP) {
                        $this->of_imgname = 'gcorderform-s'.(int)$this->context->shop->getContextShopID();
                    }

                    if (!move_uploaded_file($_FILES['gcof_img']['tmp_name'], _PS_MODULE_DIR_.$this->name.'/views/img/'.$this->of_imgname.'.'.Configuration::get('GCOF_IMG_EXT'))) {
                        $output .= $this->displayError($this->l('Error move uploaded file'));
                    }
                }
            }


            $active_groups = array();
            $groups = Group::getGroups($this->context->language->id, $this->context->shop->id);
            foreach ($groups as $group) {
                if (Tools::getValue('gcof_groups_'.$group['id_group'])) {
                    $active_groups[] = $group['id_group'];
                }
            }

            if (count($active_groups)) {
                Configuration::updateValue('GCOF_GROUPS', implode('-', $active_groups));
            }

            $categories = GcOrderForm::getCategories();
            $categories_list = array();

            foreach ($categories as $category) {
                foreach ($category as $content) {
                    if ($content['infos']['id_parent'] != 0) {
                        $categories_list[] = $content['infos'];
                    }
                }
            }

            $active_categories = array();

            foreach ($categories_list as $category_list) {
                if (Tools::getValue('gcof_categories_'.$category_list['id_category'])) {
                    $active_categories[] = $category_list['id_category'];
                }
            }

            if (count($active_categories)) {
                Configuration::updateValue('GCOF_CATEGORIES', implode('-', $active_categories));
            }

            Configuration::updateValue('GCOF_QUANTITY', Tools::getValue('gcof_quantity'));
            Configuration::updateValue('GCOF_STOCK', Tools::getValue('gcof_stock'));
            Configuration::updateValue('GCOF_IMAGE', Tools::getValue('gcof_image'));
            Configuration::updateValue('GCOF_LINK', Tools::getValue('gcof_link'));
            Configuration::updateValue('GCOF_LEFTCOLUMN', Tools::getValue('gcof_leftcolumn'));
            Configuration::updateValue('GCOF_RIGHTCOLUMN', Tools::getValue('gcof_rightcolumn'));
            Configuration::updateValue('GCOF_EMPTY', Tools::getValue('gcof_empty'));
            Configuration::updateValue('GCOF_TEMPLATE', Tools::getValue('gcof_template'));
            Configuration::updateValue('GCOF_BIG_IMAGE', Tools::getValue('gcof_big_image'));
            Configuration::updateValue('GCOF_CATEGORY_ON_LOAD', Tools::getValue('gcof_category_on_load'));
            Configuration::updateValue('GCOF_THUMBNAIL', Tools::getValue('gcof_thumbnail'));
            Configuration::updateValue('GCOF_ONLY_STOCK', Tools::getValue('gcof_only_stock'));
            Configuration::updateValue('GCOF_IMG', Tools::getValue('gcof_img'));

            $output .= $this->displayConfirmation($this->l('Settings updated'));

            $this->initialize();
        }

        return $output;
    }

    public function renderForm()
    {
        if (version_compare(_PS_VERSION_, '1.6', '<')) {
            $type = 'radio';
        } else {
            $type = 'switch';
        }

        $fields_form = array(
            'form' => array(
                'legend' => array(
                    'title' => $this->l('Display'),
                    'icon'  => 'icon-cogs'
                ),
                'input'  => array(
                    array(
                        'type'  => 'free',
                        'id'    => 'front-url',
                        'name'  => 'front-url',
                        'label' => $this->l('Front url'),
                    ),
                    array(
                        'type'    => $type,
                        'label'   => $this->l('Display left column'),
                        'name'    => 'gcof_leftcolumn',
                        'class'   => 't',
                        'is_bool' => true,
                        'values'  => array(
                            array(
                                'id'    => 'active_on',
                                'value' => 1,
                                'label' => $this->l('Enabled')
                            ),
                            array(
                                'id'    => 'active_off',
                                'value' => 0,
                                'label' => $this->l('Disabled')
                            )
                        ),
                    ),
                    array(
                        'type'    => $type,
                        'label'   => $this->l('Display right column'),
                        'name'    => 'gcof_rightcolumn',
                        'is_bool' => true,
                        'class'   => 't',
                        'values'  => array(
                            array(
                                'id'    => 'active_on',
                                'value' => 1,
                                'label' => $this->l('Enabled')
                            ),
                            array(
                                'id'    => 'active_off',
                                'value' => 0,
                                'label' => $this->l('Disabled')
                            )
                        ),
                    ),
                    array(
                        'type'     => 'select',
                        'label'    => $this->l('Template :'),
                        'desc'     => $this->l('Module template : try both'),
                        'name'     => 'gcof_template',
                        'required' => true,
                        'options'  => array(
                            'query' => $this->getTemplate(),
                            'name'  => 'name',
                            'id'    => 'id',
                        )
                    ),
                    array(
                        'type'    => $type,
                        'label'   => $this->l('Buttons for quantity fields'),
                        'name'    => 'gcof_quantity',
                        'is_bool' => true,
                        'class'   => 't',
                        'desc'    => $this->l('Will be displayed in the form'),
                        'values'  => array(
                            array(
                                'id'    => 'active_on',
                                'value' => 1,
                                'label' => $this->l('Enabled')
                            ),
                            array(
                                'id'    => 'active_off',
                                'value' => 0,
                                'label' => $this->l('Disabled')
                            )
                        ),
                    ),
                    array(
                        'type'    => $type,
                        'class'   => 't',
                        'label'   => $this->l('Empty fields'),
                        'name'    => 'gcof_empty',
                        'is_bool' => true,
                        'desc'    => $this->l('Will empty fields after add to cart'),
                        'values'  => array(
                            array(
                                'id'    => 'active_on',
                                'value' => 1,
                                'label' => $this->l('Enabled')
                            ),
                            array(
                                'id'    => 'active_off',
                                'value' => 0,
                                'label' => $this->l('Disabled')
                            )
                        ),
                    ),
                    array(
                        'type'    => $type,
                        'class'   => 't',
                        'label'   => $this->l('Stock column'),
                        'name'    => 'gcof_stock',
                        'is_bool' => true,
                        'desc'    => $this->l('Will display "stock" column'),
                        'values'  => array(
                            array(
                                'id'    => 'active_on',
                                'value' => 1,
                                'label' => $this->l('Enabled')
                            ),
                            array(
                                'id'    => 'active_off',
                                'value' => 0,
                                'label' => $this->l('Disabled')
                            )
                        ),
                    ),
                    array(
                        'type'    => $type,
                        'class'   => 't',
                        'label'   => $this->l('Link to product page'),
                        'name'    => 'gcof_link',
                        'is_bool' => true,
                        'desc'    => $this->l('Link will be on product name'),
                        'values'  => array(
                            array(
                                'id'    => 'active_on',
                                'value' => 1,
                                'label' => $this->l('Enabled')
                            ),
                            array(
                                'id'    => 'active_off',
                                'value' => 0,
                                'label' => $this->l('Disabled')
                            )
                        ),
                    ),
                    array(
                        'type'    => $type,
                        'class'   => 't',
                        'label'   => $this->l('Image column'),
                        'name'    => 'gcof_image',
                        'is_bool' => true,
                        'desc'    => $this->l('Will display "image" column'),
                        'values'  => array(
                            array(
                                'id'    => 'active_on',
                                'value' => 1,
                                'label' => $this->l('Enabled')
                            ),
                            array(
                                'id'    => 'active_off',
                                'value' => 0,
                                'label' => $this->l('Disabled')
                            )
                        ),
                    ),
                    array(
                        'type'    => $type,
                        'class'   => 't',
                        'label'   => $this->l('Only products in stock'),
                        'name'    => 'gcof_only_stock',
                        'is_bool' => true,
                        'desc'    => $this->l('Will add only products available in the form '),
                        'values'  => array(
                            array(
                                'id'    => 'active_on',
                                'value' => 1,
                                'label' => $this->l('Enabled')
                            ),
                            array(
                                'id'    => 'active_off',
                                'value' => 0,
                                'label' => $this->l('Disabled')
                            )
                        ),
                    ),
                    array(
                        'type'          => 'select',
                        'label'         => $this->l('Thumbnail Format :'),
                        'desc'          => $this->l('Image format for Image column'),
                        'name'          => 'gcof_thumbnail',
                        'default_value' => '',
                        'options'       => array(
                            'query'   => ImageType::getImagesTypes('products'),
                            'name'    => 'name',
                            'id'      => 'name',
                            'default' => array(
                                'label' => $this->l('-- Select a format --'),
                                'value' => ''
                            )
                        )
                    ),
                    array(
                        'type'          => 'select',
                        'label'         => $this->l('Big Format :'),
                        'desc'          => $this->l('Image format for Image column on hover'),
                        'name'          => 'gcof_big_image',
                        'default_value' => '',
                        'options'       => array(
                            'query'   => ImageType::getImagesTypes('products'),
                            'name'    => 'name',
                            'id'      => 'name',
                            'default' => array(
                                'label' => $this->l('-- Select a format --'),
                                'value' => ''
                            )
                        )
                    ),
                    array(
                        'type'    => 'select',
                        'label'   => $this->l('Category to display on load'),
                        'name'    => 'gcof_category_on_load',
                        'options' => array(
                            'query'   => GcOrderForm::getCategoriesInString(1),
                            'name'    => 'name',
                            'id'      => 'id_category',
                            'default' => array(
                                'label' => $this->l('-- Nothing --'),
                                'value' => '0'
                            )
                        ),
                        'desc'    => $this->l('Will be displayed in the selector'),
                    ),
                    array(
                        'type'    => 'file',
                        'label'   => $this->l('Picture for column block'),
                        'name'    => 'gcof_img',
                        'is_bool' => false,
                        'desc'    => $this->l('Will be displayed as 155x163'),
                    ),
                    array(
                        'type'   => 'checkbox',
                        'label'  => $this->l('Customer groups'),
                        'name'   => 'gcof_groups',
                        'values' => array(
                            'query' => Group::getGroups($this->context->language->id, $this->context->shop->id),
                            'id'    => 'id_group',
                            'name'  => 'name',
                            'value' => 1
                        ),
                        'desc'   => $this->l('Will access to the Order Form'),
                    ),
                    array(
                        'type'   => 'checkbox',
                        'label'  => $this->l('Categories'),
                        'name'   => 'gcof_categories',
                        'values' => array(
                            'query' => GcOrderForm::getCategoriesInString(),
                            'id'    => 'id_category',
                            'name'  => 'name',
                            'value' => 1
                        ),
                        'desc'   => $this->l('Will be displayed in the selector'),
                    )
                ),
                'submit' => array(
                    'title' => $this->l('Save'),
                    'class' => 'btn btn-default pull-right'
                )
            ),
        );

        $helper = new HelperForm();
        $helper->title = $this->l('Order Form');
        $helper->show_toolbar = true;
        $helper->table = $this->table;
        $lang = new Language((int)Configuration::get('PS_LANG_DEFAULT'));
        $helper->default_form_language = $lang->id;
        $helper->allow_employee_form_lang =
            Configuration::get('PS_BO_ALLOW_EMPLOYEE_FORM_LANG') ? Configuration::get('PS_BO_ALLOW_EMPLOYEE_FORM_LANG') : 0;
        $this->fields_form = array();
        $helper->toolbar_btn = array(
            'save' => array('href' => '#', 'desc' => $this->l('Save'))
        );

        $helper->identifier = $this->identifier;
        $helper->submit_action = 'submitAdvConf';
        $helper->currentIndex = $this->context->link->getAdminLink('AdminModules', false)
            .'&configure='.$this->name.'&tab_module='.$this->tab.'&module_name='.$this->name;
        $helper->token = Tools::getAdminTokenLite('AdminModules');
        $helper->tpl_vars = array(
            'fields_value' => $this->getConfigFieldsValues(),
            'languages'    => $this->context->controller->getLanguages(),
            'id_language'  => $this->context->language->id
        );

        return $helper->generateForm(array($fields_form));
    }

    public function getConfigFieldsValues()
    {
        $values = array(
            'gcof_quantity'         => Tools::getValue('gcof_quantity', Configuration::get('GCOF_QUANTITY')),
            'gcof_empty'            => Tools::getValue('gcof_empty', Configuration::get('GCOF_EMPTY')),
            'gcof_stock'            => Tools::getValue('gcof_stock', Configuration::get('GCOF_STOCK')),
            'gcof_image'            => Tools::getValue('gcof_image', Configuration::get('GCOF_IMAGE')),
            'front-url'             => '<a href="'.$this->context->link->getModuleLink($this->name, 'default', array(), Tools::usingSecureMode()).'" target="_blank">'.$this->context->link->getModuleLink($this->name, 'default', array(), Tools::usingSecureMode()).'</a>',
            'gcof_link'             => Tools::getValue('gcof_link', Configuration::get('GCOF_LINK')),
            'gcof_leftcolumn'       => Tools::getValue('gcof_leftcolumn', Configuration::get('GCOF_LEFTCOLUMN')),
            'gcof_rightcolumn'      => Tools::getValue('gcof_rightcolumn', Configuration::get('GCOF_RIGHTCOLUMN')),
            'gcof_only_stock'       => Tools::getValue('gcof_only_stock', Configuration::get('GCOF_ONLY_STOCK')),
            'gcof_thumbnail'        => Tools::getValue('gcof_thumbnail', Configuration::get('GCOF_THUMBNAIL')),
            'gcof_big_image'        => Tools::getValue('gcof_big_image', Configuration::get('GCOF_BIG_IMAGE')),
            'gcof_category_on_load' => Tools::getValue('gcof_category_on_load', Configuration::get('GCOF_CATEGORY_ON_LOAD')),
            'gcof_template'         => Tools::getValue('gcof_template', Configuration::get('GCOF_TEMPLATE')),
            'gcof_img'              => Tools::getValue('gcof_img', Configuration::get('GCOF_IMG'))
        );

        if (Configuration::get('GCOF_GROUPS')) {
            $groups = explode('-', Configuration::get('GCOF_GROUPS'));
            foreach ($groups as $group) {
                $values['gcof_groups_'.$group] = 1;
            }
        }

        if (Configuration::get('GCOF_CATEGORIES')) {
            $categories = explode('-', Configuration::get('GCOF_CATEGORIES'));
            foreach ($categories as $category) {
                $values['gcof_categories_'.$category] = 1;
            }
        }

        return $values;
    }

    public function hookDisplayHeader()
    {
        if (isset($this->context->controller->module->name) && ($this->context->controller->module->name == $this->name)) {
            if (self::hasAccess()) {
                if (version_compare(_PS_VERSION_, '1.7', '<')) {
                    $this->context->controller->addJquery();
                    $this->context->controller->addCSS($this->_path.'views/css/gcorderform.css', 'all');
                    $this->context->controller->addJS($this->_path.'views/js/lightbox.min.js');
                    $this->context->controller->addCSS($this->_path.'views/css/lightbox.css', 'all');
                } else {
                    $this->context->controller->registerStylesheet(
                        'modules-gcorderform2',
                        'modules/'.$this->name.'/views/css/gcorderform.css',
                        array('media' => 'all', 'priority' => 155)
                    );
                    $this->context->controller->registerStylesheet(
                        'modules-gcorderform3',
                        'modules/'.$this->name.'/views/css/lightbox.css',
                        array('media' => 'all', 'priority' => 155)
                    );
                    $this->context->controller->registerJavascript(
                        'modules-gcorderform',
                        'modules/'.$this->name.'/views/js/lightbox.min.js',
                        array('position' => 'bottom', 'priority' => 80)
                    );
                }
            }
        } else {
            if (self::hasAccess()) {
                if (version_compare(_PS_VERSION_, '1.7', '<')) {
                    $this->context->controller->addCSS($this->_path.'views/css/gcorderform-out.css', 'all');
                } else {
                    $this->context->controller->registerStylesheet(
                        'modules-gcorderform1',
                        'modules/'.$this->name.'/views/css/gcorderform-out.css',
                        array('media' => 'all', 'priority' => 155)
                    );
                }
            }
        }
    }

    public function hookbackOfficeHeader()
    {
        if ((Tools::getValue('module_name') == $this->name) || (Tools::getValue('configure') == $this->name)) {
            if (version_compare(_PS_VERSION_, '1.7', '<')) {
                $this->context->controller->addJquery();
            }
        }
    }

    public static function hasAccess()
    {
        $active_groups = explode('-', Configuration::get('GCOF_GROUPS'));
        $groups = Customer::getGroupsStatic(Context::getContext()->customer->id);

        foreach ($groups as $group) {
            if (in_array($group, $active_groups)) {
                return true;
            }
        }

        return false;
    }

    public function hookDisplayRightColumn($params)
    {
        return $this->hookDisplayLeftColumn($params);
    }

    public function hookDisplayLeftColumn()
    {
        if (GcOrderForm::hasAccess()) {
            $this->smarty->assign('gcof_picture', $this->context->link->protocol_content.$this->of_img);

            if (version_compare(_PS_VERSION_, '1.7', '<')) {
                return $this->display(__FILE__, 'left-column.tpl');
            } else {
                return $this->fetch('module:gcorderform/views/templates/hook/left-column.tpl');
            }
        }
    }

    public static function getCategories()
    {
        return Category::getCategories(Context::getContext()->language->id);
    }

    public static function getCategoriesInString($everything = 0)
    {
        $categories = GcOrderForm::getCategories();
        $categories_list = array();

        if ($everything == 1) {
            $categories_list[] = array(
                'id_category' => 1,
                'name'        => sprintf('Root'),
            );
        }

        foreach ($categories as $category) {
            foreach ($category as $content) {
                if (($content['infos']['id_parent'] != 0) && ($content['infos']['id_shop'] == Context::getContext()->shop->id)) {
                    $categories_list[] = $content['infos'];
                }
            }
        }

        return $categories_list;
    }

    public static function getCountOfProductsInCategory($id_category = null)
    {
        if (!$id_category) {
            return false;
        }

        $id_lang = Context::getContext()->language->id;
        $my_counted_category = new Category($id_category, $id_lang);

        return $my_counted_category->getProducts($id_lang, 1, 10000000, null, null, true, true);
    }

    public static function getCategoriesOfCategory($id_category = null)
    {
        $my_context = Context::getContext();
        $id_lang = $my_context->language->id;
        $categories = array();

        $my_category_obj = new Category($id_category, $id_lang);
        $my_categories = $my_category_obj->getSubCategories($id_lang);

        foreach ($my_categories as $my_category) {
            $my_category_obj = new Category($my_category['id_category'], $id_lang);

            if ($my_context->customer->isLogged()) {
                if ($my_category_obj->checkAccess((int)$my_context->customer->id)) {
                    $categories[] = array(
                        'id_category'  => $my_category_obj->id,
                        'name'         => $my_category_obj->name,
                        'id_image'     => $my_category_obj->id_image,
                        'link_rewrite' => $my_category_obj->link_rewrite
                    );
                }
            } else {
                $categories[] = array(
                    'id_category'  => $my_category_obj->id,
                    'name'         => $my_category_obj->name,
                    'id_image'     => $my_category_obj->id_image,
                    'link_rewrite' => $my_category_obj->link_rewrite
                );
            }
        }

        $my_definitive_category = array();

        foreach ($categories as &$category) {
            $category['my_image'] = $my_context->link->getCatImageLink($category['link_rewrite'], $category['id_category'], 'order_form_cat_default');
            $my_definitive_category[] = $category;
        }

        return $my_definitive_category;
    }

    public static function getPriceOfProducts($id_product = null, $id_product_attribute = null, $quantity = 1)
    {
        $my_context = Context::getContext();
        $my_customer = null;
        $specific_price_output = null;

        if ($my_context->customer->isLogged()) {
            $my_customer = (int)$my_context->customer->id;
            if (Group::getPriceDisplayMethod($my_context->customer->id_default_group) == 1) {
                $usetax = false;
            } else {
                $usetax = true;
            }
        } else {
            if (Group::getPriceDisplayMethod(1) == 1) {
                $usetax = false;
            } else {
                $usetax = true;
            }
        }

        return Tools::displayPrice(Product::getPriceStatic($id_product, $usetax, $id_product_attribute, 2, null, false, true, $quantity, false, $my_customer, null, null, $specific_price_output, true, true, $my_context, true));
    }

    public static function getProductsOfCategory($id_category = null)
    {
        $my_context = Context::getContext();
        $id_lang = $my_context->language->id;
        $my_customer = null;
        $specific_price_output = null;

        if ($my_context->customer->isLogged()) {
            $my_customer = (int)$my_context->customer->id;
            if (Group::getPriceDisplayMethod($my_context->customer->id_default_group) == 1) {
                $usetax = false;
            } else {
                $usetax = true;
            }
        } else {
            if (Group::getPriceDisplayMethod(1) == 1) {
                $usetax = false;
            } else {
                $usetax = true;
            }
        }

        if (!$id_category) {
            $my_products = Product::getProducts($id_lang, 0, 100000, 'name', 'asc');
        } else {
            $my_category = new Category($id_category, $id_lang);
            $my_products = $my_category->getProducts($id_lang, 1, GcOrderForm::getCountOfProductsInCategory($id_category), 'name', 'asc');
        }

        $my_definitive_products = array();

        foreach ($my_products as $my_product) {
            if (Configuration::get('GCOF_IMAGE') == 1) {
                $product_image = Image::getCover($my_product['id_product']);

                if (empty($product_image['id_image'])) {
                    $my_image = $my_product['id_product'].'-0';
                } else {
                    $my_image = $my_product['id_product'].'-'.$product_image['id_image'];
                }

                $my_image_big = $my_context->link->getImageLink($my_product['link_rewrite'], $my_image, Configuration::get('GCOF_BIG_IMAGE'));
                $my_product['big'] = $my_image_big;
            }
            $my_prod_obj = new Product($my_product['id_product'], true, $id_lang);
            $my_product['link'] = $my_context->link->getProductLink($my_prod_obj, $my_prod_obj->link_rewrite, null, null, $my_context->cookie->id_lang, $my_context->shop->id, Product::getDefaultAttribute($my_product['id_product']));
            $my_product['declinaison'] = GcOrderForm::getDecliOfProduct($my_product['id_product']);
            $my_product['price'] = Tools::displayPrice(Product::getPriceStatic($my_product['id_product'], $usetax, null, 2, null, false, true, 1, false, $my_customer, null, null, $specific_price_output, true, true, $my_context, true));
            $my_product['quantityavailable'] = Product::getQuantity($my_product['id_product']);

            if (Configuration::get('GCOF_ONLY_STOCK') == 1) {
                if ($my_product['quantityavailable'] > 0) {
                    $my_definitive_products[] = $my_product;
                }
            } else {
                $my_definitive_products[] = $my_product;
            }
        }
        return $my_definitive_products;
    }

    public static function getDecliOfProduct($my_id_product)
    {
        $my_context = Context::getContext();

        if (Configuration::get('GCOF_IMAGE') == 1) {
            $product_image = Image::getCover($my_id_product);
        }

        $my_product = new Product($my_id_product, true, (int)$my_context->cookie->id_lang);
        $usetax = Group::getDefaultPriceDisplayMethod();
        $combinations = array();
        $my_customer = null;
        $specific_price_output = null;

        if ($my_context->customer->isLogged()) {
            $my_customer = (int)$my_context->customer->id;
            if (Group::getPriceDisplayMethod($my_context->customer->id_default_group) == 1) {
                $usetax = false;
            } else {
                $usetax = true;
            }
        } else {
            if (Group::getPriceDisplayMethod(1) == 1) {
                $usetax = false;
            } else {
                $usetax = true;
            }
        }

        $attributes_groups = $my_product->getAttributesGroups((int)$my_context->cookie->id_lang);

        if (is_array($attributes_groups) && $attributes_groups) {
            foreach ($attributes_groups as $row) {
                if (Configuration::get('GCOF_IMAGE') == 1) {
                    $my_decli_image = 0;

                    if (_PS_VERSION_ >= 1.6) {
                        $product_decli_images = Image::getImages((int)Configuration::get('PS_LANG_DEFAULT'), $my_product->id, $row['id_product_attribute']);
                        foreach ($product_decli_images as $product_decli_image) {
                            $my_decli_image = $product_decli_image['id_image'];
                            break;
                        }
                    } else {
                        $product_decli_images = Product::_getAttributeImageAssociations($row['id_product_attribute']);

                        foreach ($product_decli_images as $product_decli_image) {
                            $my_decli_image = $product_decli_image;
                            break;
                        }
                    }

                    if ($my_decli_image == 0) {
                        $my_decli_image = $product_image['id_image'];
                    }

                    $combinations[$row['id_product_attribute']]['big'] = $my_context->link->getImageLink($my_product->link_rewrite, $my_product->id.'-'.$my_decli_image, Configuration::get('GCOF_BIG_IMAGE'));
                }

                $combinations[$row['id_product_attribute']]['attributes_values'][$row['id_attribute_group']] = $row['attribute_name'];
                $combinations[$row['id_product_attribute']]['minimal_quantity'] = $row['minimal_quantity'];
                $combinations[$row['id_product_attribute']]['reference'] = $row['reference'];
                $combinations[$row['id_product_attribute']]['link'] = $my_context->link->getProductLink($my_product, $my_product->link_rewrite, null, null, $my_context->cookie->id_lang, $my_context->shop->id, $row['id_product_attribute']);
                $combinations[$row['id_product_attribute']]['quantityavailable'] = Product::getQuantity($my_product->id, $row['id_product_attribute']);
                $combinations[$row['id_product_attribute']]['price'] = Tools::displayPrice(Product::getPriceStatic($my_product->id, $usetax, $row['id_product_attribute'], 2, null, false, true, 1, false, $my_customer, null, null, $specific_price_output, true, true, $my_context, true));
            }
        } else {
            return 'ProdSansDecli##'.$my_product->minimal_quantity;
        }

        $return = array();
        $mastring = array();
        foreach ($combinations as $k_combination => $v_combination) {
            $mastring['id_product_attribute'] = $k_combination;
            $my_libelle = '';

            foreach ($v_combination['attributes_values'] as $composant) {
                $my_libelle .= $composant.' - ';
            }

            $mastring['libelle'] = rtrim($my_libelle, ' - ');
            $mastring['minimal_quantity'] = $v_combination['minimal_quantity'];
            $mastring['reference'] = $v_combination['reference'];
            $mastring['quantityavailable'] = $v_combination['quantityavailable'];
            $mastring['price'] = $v_combination['price'];
            $mastring['link'] = $v_combination['link'];

            if (Configuration::get('GCOF_IMAGE') == 1) {
                $mastring['big'] = $v_combination['big'];
            }

            if (Configuration::get('GCOF_ONLY_STOCK') == 1) {
                if ($mastring['quantityavailable'] > 0) {
                    $return[] = $mastring;
                }
            } else {
                $return[] = $mastring;
            }
        }

        usort($return, function ($a, $b) {
            return strcmp($a["libelle"], $b["libelle"]);
        });

        return $return;
    }

    public function getTemplate()
    {
        $tab = array(
            array(
                'id'   => 1,
                'name' => 'version 1'
            ),
            array(
                'id'   => 2,
                'name' => 'version 2'
            )
        );

        return $tab;
    }

    public function hookOverrideLayoutTemplate($params)
    {
        $overridden_layout = $params['default_layout'];
        if ($params['controller']->getPageName() != 'module-'.$this->name.'-default') {
            return $overridden_layout;
        }
        $left = Configuration::get('GCOF_LEFTCOLUMN');
        $right = Configuration::get('GCOF_RIGHTCOLUMN');
        if ($left && $right) { 
            $overridden_layout = 'layouts/layout-both-columns.tpl';
        } elseif ($left && !$right) {
            $overridden_layout = 'layouts/layout-left-column.tpl';
        } elseif (!$left && $right) {
            $overridden_layout = 'layouts/layout-right-column.tpl';
        } else {
            $overridden_layout = 'layouts/layout-full-width.tpl';
        }

        return $overridden_layout;
    }

    public function hookDisplayBeforeBodyClosingTag()
    {
        if (isset($this->context->controller->module->name) && ($this->context->controller->module->name == $this->name)) {
            if (self::hasAccess()) {
                $search_url = $this->context->link->getPageLink('search', (int)Tools::usingSecureMode(), null, null, false, null, false);
                $cart_url = $this->context->link->getPageLink('cart', (int)Tools::usingSecureMode(), null, null, false, null, false);
                $gcof_url = $this->context->link->getModuleLink('gcorderform', 'actions', array('process' => 'get'), (int)Tools::usingSecureMode());

                $this->context->smarty->assign(array(
                    'gcof_lang'             => Context::getContext()->cookie->id_lang,
                    'search_controller_url' => $search_url,
                    'cart_url'              => $cart_url,
                    'gcof_url'              => $gcof_url,
                    'gcof_quantity_buttons' => Configuration::get('GCOF_QUANTITY'),
                    'gcof_picture'          => Configuration::get('GCOF_PICTURE'),
                    'gcof_link'             => Configuration::get('GCOF_LINK'),
                    'gcof_stock'            => Configuration::get('GCOF_STOCK'),
                    'gcof_onlyinstock'      => Configuration::get('GCOF_ONLYINSTOCK'),
                    'gcof_price'            => Configuration::get('GCOF_PRICE'),
                    'gcof_empty'            => Configuration::get('GCOF_EMPTY'),
                    'gcof_img'              => Configuration::get('GCOF_IMG'),
                    'gcof_confirmtxt'       => $this->l('You selected products, would you like to add them to the cart ?')
                ));

                return $this->fetch('module:gcorderform/views/templates/hook/javascript_footer-'.Configuration::get('GCOF_TEMPLATE').'.tpl');
            }
        }
    }

    public function hookDisplayCustomerAccount()
    {
        if (self::hasAccess()) {
            if (version_compare(_PS_VERSION_, '1.7', '<')) {
                return $this->display(__FILE__, 'my_account.tpl');
            } else {
                return $this->fetch('module:gcorderform/views/templates/hook/my_account.tpl');
            }
        }
    }

}
