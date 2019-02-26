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

class GcOrderFormDefaultModuleFrontController extends ModuleFrontController
{
    public function initContent()
    {
        if (GcOrderForm::hasAccess()) {
            if (Configuration::get('GCOF_LEFTCOLUMN')) {
                $this->display_column_left = true;
            } else {
                $this->display_column_left = false;
            }

            if (Configuration::get('GCOF_RIGHTCOLUMN')) {
                $this->display_column_right = true;
            } else {
                $this->display_column_right = false;
            }

            parent::initContent();

            $results = explode('-', Configuration::get('GCOF_CATEGORIES'));
            $on_load = Configuration::get('GCOF_CATEGORY_ON_LOAD', 0);

            $categories = array();

            foreach ($results as $row) {
                $my_category = new Category($row, $this->context->language->id);
                if ($this->context->customer->isLogged()) {
                    if ($my_category->checkAccess((int)$this->context->customer->id)) {
                        $categories[] = array('id_category' => $my_category->id, 'name' => $my_category->name, 'link_rewrite' => $my_category->link_rewrite);
                    }
                } else {
                    if ($my_category->checkAccess(1)) {
                        $categories[] = array('id_category' => $my_category->id, 'name' => $my_category->name, 'link_rewrite' => $my_category->link_rewrite);
                    }
                }
            }

            if (!$this->context->cart->id) {
                if (Context::getContext()->cookie->id_guest) {
                    $guest = new Guest(Context::getContext()->cookie->id_guest);
                    $this->context->cart->mobile_theme = $guest->mobile_theme;
                }
                $this->context->cart->add();
                if ($this->context->cart->id) {
                    $this->context->cookie->id_cart = (int)$this->context->cart->id;
                }
            }

            $products = array();

            if ($on_load != 0) {
                if ($on_load == 1) {
                    $products = GcOrderForm::getProductsOfCategory();
                } else {
                    $products = GcOrderForm::getProductsOfCategory((int)$on_load);
                }
            }

            $this->context->smarty->assign(array(
                'gcof_ssl'              => (int)Tools::usingSecureMode(),
                'gcof_categories'       => $categories,
                'gcof_quantity_buttons' => Configuration::get('GCOF_QUANTITY'),
                'gcof_empty'            => Configuration::get('GCOF_EMPTY'),
                'gcof_image'            => Configuration::get('GCOF_IMAGE'),
                'gcof_link'             => Configuration::get('GCOF_LINK'),
                'gcof_image_size'       => Image::getSize(Configuration::get('GCOF_THUMBNAIL')),
                'gcof_big_size'         => Image::getSize(Configuration::get('GCOF_BIG_IMAGE')),
                'gcof_cat_size'         => Image::getSize('order_form_cat_default'),
                'gcof_stock'            => Configuration::get('GCOF_STOCK'),
                'gcof_products'         => $products,
                'gcof_confirmtxt'       => $this->module->l('You selected products, would you like to add them to the cart ?'),
                'gcof_url'              => $this->context->link->getModuleLink('gcorderform', 'actions', array('process' => 'get'), (int)Tools::usingSecureMode()),
                'gcof_img_dir'          => Tools::getShopDomain(true).__PS_BASE_URI__.'modules/'.$this->module->name.'/views/img/',
            ));

            if (version_compare(_PS_VERSION_, '1.7', '<')) {
                if (version_compare(_PS_VERSION_, '1.6', '<')) {
                    $this->context->smarty->assign('gcof_psversion', '15');
                } else {
                    $this->context->smarty->assign('gcof_psversion', '16');
                }
                $this->setTemplate('gcorderform-form-old-'.Configuration::get('GCOF_TEMPLATE').'.tpl');
            } else {
                $this->context->smarty->assign('gcof_psversion', '17');
                $this->setTemplate('module:gcorderform/views/templates/front/gcorderform-form-'.Configuration::get('GCOF_TEMPLATE').'.tpl');
            }
        } else {
            Tools::redirect(__PS_BASE_URI__);
        }
    }
}
