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

class GcOrderFormActionsModuleFrontController extends ModuleFrontController
{
    public $id_category;

    public function init()
    {
        parent::init();
        $this->id_category = (int)Tools::getValue('id_category', 0);
        $this->id_product = (int)Tools::getValue('id_product');
        $this->id_product_attribute = (int)Tools::getValue('id_product_attribute');
        $this->quantity = (int)Tools::getValue('quantity');
    }

    public function postProcess()
    {
        if (version_compare(_PS_VERSION_, '1.7', '<')) {
            if (Tools::getValue('process') == 'get') {
                echo Tools::jsonEncode($this->processGetProducts());
            }
            if (Tools::getValue('process') == 'categories') {
                echo Tools::jsonEncode($this->processGetCategories());
            }
            if (Tools::getValue('process') == 'price') {
                echo Tools::jsonEncode($this->processGetPrice());
            }
        } else {
            if (Tools::getValue('process') == 'get') {
                echo json_encode($this->processGetProducts());
            }
            if (Tools::getValue('process') == 'categories') {
                echo json_encode($this->processGetCategories());
            }
            if (Tools::getValue('process') == 'price') {
                echo json_encode($this->processGetPrice());
            }
        }
        die();
    }

    public function processGetCategories()
    {
        $my_categories = GcOrderForm::getCategoriesOfCategory($this->id_category);

        return $my_categories;
    }

    public function processGetPrice()
    {
        $my_price = GcOrderForm::getPriceOfProducts($this->id_product, $this->id_product_attribute, $this->quantity);

        return $my_price;
    }

    public function processGetProducts()
    {
        $my_products = GcOrderForm::getProductsOfCategory($this->id_category);

        return $my_products;
    }
}
