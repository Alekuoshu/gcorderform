{*
 * GcOrderForm
 *
 * @author    Grégory Chartier <hello@gregorychartier.fr>
 * @copyright 2018 Grégory Chartier (https://www.gregorychartier.fr)
 * @license   Commercial license see license.txt
 * @category  Prestashop
 * @category  Module
 *
*}

<script type="text/javascript">
    var gcof_empty = {$gcof_empty|intval};
    var ps = '{$gcof_psversion|escape:'html':'UTF-8'}';
    var gcof_stock = {$gcof_stock|intval};
    var gcof_image = {$gcof_image|intval};
	{if $gcof_image}
    var image_size_width = {$gcof_image_size.width|intval};
    var image_size_height = {$gcof_image_size.height|intval};
	{/if}
    var gcof_img_dir = '{$gcof_img_dir|escape:'html':'UTF-8'}';
    var gcof_url = '{$link->getModuleLink('gcorderform', 'actions', ['process' => 'get'], {$gcof_ssl|intval})|escape:'html':'UTF-8'}';
    var gcof_cart_url = "{$cart_url|escape:'html':'UTF-8'}";
    var gcof_categories = '{$link->getModuleLink('gcorderform', 'actions', ['process' => 'categories'], {$gcof_ssl|intval})|escape:'html':'UTF-8'}';
    var gcof_quantitybuttons = {$gcof_quantity_buttons|intval};
    var gcof_confirmtxt = "{$gcof_confirmtxt|escape:'html':'UTF-8'}";

    // <![CDATA[
	{literal}
    $(document).ready(function () {
        $('#ofsubcategories').unbind('click').on('click', '.filter', function () {
            if (checkFormFill()) {
                hoverIt($(this));
                if (!$(this).hasClass('n2')) {
                    displaySubCategories($(this).parent());
                }

                if (!$(this).hasClass('n2')) {
                    refreshProductList($(this).parent());
                }
                else {
                    refreshProductList($(this));
                }
            }

            return false;
        });
        
        $(".qty").unbind('change').on('change', '.quantity_wanted', function() {
	        checkMinimal($(this));
			return true;
        });

        $('.name').unbind('click').on('click', '.product_img_link', function () {
            checkFormFill();
            return true;
        });

        $('#add_to_cart_fix').unbind('click').click(function () {
            $('tbody tr').each(function () {
                if ($(this).find('.quantity_wanted').val() > 0) {
                    var currentRow = $(this);
                    $.post(gcof_cart_url+'?rand=' + new Date().getTime(), {
						action: "update",
						id_product: parseInt(currentRow.find('.name .id_product').val()),
						id_product_attribute: parseInt(currentRow.find('.name .id_product_attribute').val()),
						ajax: true,
						qty: parseInt(currentRow.find('.quantity_wanted').val()),
			            headers: {
            			    "cache-control": "no-cache"
			            },
						async: true,
						token: prestashop["static_token"],
						add: 1,
			            cache: false,
					}, null, 'json').then(function (resp) {
						prestashop.emit('updateCart', {
                        	reason: {
                            	idProduct: resp.id_product,
                                idProductAttribute: resp.id_product_attribute,
                                linkAction: 'add-to-cart'
                            }
                        });
                    });
                    if (gcof_empty == 1)
                        currentRow.find('.quantity input').val("0");
                }
            });
            return false;
        });

        $('.rollup').unbind('click').on('click', '.enrouleur', function () {
            var givemeyourid = $(this).attr("id");
            $(this).parent().parent().parent().find('.decliline' + givemeyourid).slideToggle();
            if ($(this).html() == '+') {
                $(this).html('-');
                $(this).css('line-height', '17px');
            }
            else {
                $(this).html('+');
                $(this).css('line-height', '20px');
            }

            return false;
        });

        if (gcof_quantitybuttons == 1)
            createProductSpin();
    });

    function checkFormFill(myObject) {
        var needconfirm = 0;
        $('.orderform_content table tbody tr').each(function () {
            if ($(this).find('.quantity input').val() > 0) {
                needconfirm = 1;
                return;
            }
        });

        if (needconfirm == 1) {
            if (confirm(gcof_confirmtxt)) {
                $('tbody tr').each(function () {
                    if ($(this).find('.quantity_wanted').val() > 0) {
                        var currentRow = $(this);

                        $.post(gcof_cart_url+'?rand=' + new Date().getTime(), {
                            action: "update",
                            id_product: parseInt(currentRow.find('.name .id_product').val()),
                            id_product_attribute: parseInt(currentRow.find('.name .id_product_attribute').val()),
                            ajax: true,
                            qty: parseInt(currentRow.find('.quantity_wanted').val()),
                            headers: {
                                "cache-control": "no-cache"
                            },
                            async: true,
                            token: prestashop["static_token"],
                            add: 1,
                            cache: false,
                        }, null, 'json').then(function (resp) {
                            prestashop.emit('updateCart', {
                                reason: {
                                    idProduct: resp.id_product,
                                    idProductAttribute: resp.id_product_attribute,
                                    linkAction: 'add-to-cart'
                                }
                            });
                        });

                        if (gcof_empty == 1)
                            currentRow.find('.quantity input').val("0");
                    }
                });
                return true;
            }
        }
        return true;
    }

    function displaySubCategories(myObject) {
        lerel = myObject.attr('rel');
        $.ajax({
            url: gcof_categories,
            type: "GET",
            dataType: 'json',
            data: "id_category=" + lerel,
            success: function (data2) {
                var element;
                $('#ofsubcategoriesn2 ul li').remove();
                if (data2 == null || data2.length == 0)
                    $('#ofsubcategoriesn2').slideUp();
                else {
                    $('#ofsubcategoriesn2').slideDown();
                    $('#ofsubcategoriesn2').find('span.cat').html(myObject.attr('title'));
                    $.each(data2, function (index, element) {
                        element = '<li>' +
                            '<div class="subcategory-image">' +
                            '<a rel="' + element.id_category + '" title="' + element.name + '" class="img filter n2">' +
                            '<img class="replace-2x catimage" src="' + element.my_image + '" alt="' + element.name + '" width="80" height="80">' +
                            '</a>' +
                            '</div>' +
                            '<h5 class="subcategory-name">' + element.name + '</a></h5>' +
                            '</li>';

                        var newElement = $(element).clone();
                        $('#ofsubcategoriesn2 ul').append(newElement);
                        BindCat(newElement.find('.filter'));
                        BindRefresh(newElement.find('.filter'));
                    });
                }
            },
            error: function (resultat, statut, erreur) {
                $('#ofsubcategoriesn2').slideUp();
            }
        });
    }

    function refreshProductList(myObject) {
        lerel = myObject.attr('rel');
        $.ajax({
            url: gcof_url,
            type: "GET",
            dataType: 'json',
            data: "id_category=" + lerel,
            success: function (data) {
                var cell_image, cell_reference, cell_name, cell_decli, cell_stock, cell_quantity, cell_price, cell_enrouleur, row;
                $('.orderform_content table tbody tr').remove();
                $.each(data, function (index, element) {
                    if ((!$.isArray(element.declinaison)) && (element.declinaison.substr(0, 15) == "ProdSansDecli##")) {
                        if (gcof_image == 1) {
                            if (typeof element.big != "undefined")
                                cell_image = '<td class="image"><a href="' + element.big + '" data-lightbox="' + element.name + element.id_product + '" data-title="' + element.name + '" title="' + element.name + '"><img src="' + element.big + '" alt="' + element.name + '" width="' + image_size_width + '" height="' + image_size_height + '" /></a></td>';
                            else
                                cell_image = '<td class="image"></td>';
                        } else {
	                        cell_image = '<td class="image"></td>';
                        }
                        cell_reference = '<td class="ref"><p class="ref">' + element.reference + '</p></td>';
                        cell_name = '<td class="name"><a class="product_img_link" href="' + element.link + '" title="' + element.name + '"><span class="title">' + element.name + '</span><input type="hidden" value="' + element.id_product + '" class="id_product"/></a><input type="hidden" value="0" class="id_product_attribute"/></td>';
                        cell_enrouleur = '<td class="rollup">&nbsp;</td>'
                        if (gcof_stock == 1)
                            cell_stock = '<td class="stock">' + element.quantityavailable + '</td>';

                        if (element.minimal_quantity > 0)
                            cell_quantity = '<td class="quantity text-center"><div class="product-quantity clearfix"><div class="qty"><input type="text" name="qty" class="quantity_wanted input-group" value="0" min="' + element.minimal_quantity + '" max="99999"></div></div>';
                        else
                            cell_quantity = '<td class="quantity text-center"><div class="product-quantity clearfix"><div class="qty"><input type="text" name="qty" class="quantity_wanted input-group" value="0" min="0" max="99999"></div></div>';

                        cell_price = '<td class="price">' + element.price + '</td>';

                        row = '<tr class="item">';
                        row = row + cell_image;
                        row = row + cell_reference + cell_name + cell_enrouleur;
                        if (gcof_stock == 1)
                            row = row + cell_stock;

                        row = row + cell_quantity + cell_price + '</tr>';

                        var newRow = $(row).clone();
                        $('.orderform_content table tbody').append(newRow);
                    } else {

                        if (gcof_image == 1) {
                            if (typeof element.big != "undefined")
                                cell_image = '<td class="image"><a href="' + element.big + '" data-lightbox="' + element.name + element.id_product + '" data-title="' + element.name + '" title="' + element.name + '"><img src="' + element.big + '" alt="' + element.name + '" width="' + image_size_width + '" height="' + image_size_height + '" /></a></td>';
                            else
                                cell_image = '<td class="image"></td>';
                        } else {
                        	cell_image = '<td class="image"></td>';
                        }
                        cell_reference = '<td class="ref"><p class="ref"></p></td>';
                        cell_name = '<td class="name"><a class="product_img_link" href="' + element.link + '" title="' + element.name + '"><span class="title">' + element.name + '</span></a><input type="hidden" value="' + element.id_product + '" class="id_product"/><input type="hidden" value="0" class="id_product_attribute"/></td>';
                        cell_enrouleur = '<td class="rollup"><span class="enrouleur" id="' + element.id_product + '">+</span></td>'
                        if (gcof_stock == 1)
                            cell_stock = '<td class="stock"></td>';
                        cell_quantity = '<td class="quantity text-center"></td>';
                        cell_price = '<td class="price"></td>';

                        row = '<tr class="item">';

                        row = row + cell_image;
                        row = row + cell_reference + cell_name + cell_enrouleur;
                        if (gcof_stock == 1)
                            row = row + cell_stock;

                        row = row + cell_quantity + cell_price + '</tr>';

                        var newRow = $(row).clone();
                        $('.orderform_content table tbody').append(newRow);
                        $.each(element.declinaison, function (index2, elementdecli) {
                            if (gcof_image == 1) {
                                if (typeof elementdecli.big != "undefined")
                                    cell_image = '<td class="image"><a href="' + elementdecli.big + '" data-lightbox="' + element.name + element.id_product + ' ' + elementdecli.libelle + '" data-title="' + element.name + ' ' + elementdecli.libelle + '" title="' + element.name + ' ' + elementdecli.libelle + '"><img src="' + elementdecli.big + '#" alt="' + element.name + '" width="' + image_size_width + '" height="' + image_size_height + '" /></a></td>';
                                else
                                    cell_image = '<td class="image"></td>';
                            } else {
                            	cell_image = '<td class="image"></td>';
                            }
                            cell_reference = '<td class="ref"><p class="ref">' + elementdecli.reference + '</p></td>';
                            cell_name = '<td class="name"><span class="title">' + element.name + '</span><input type="hidden" value="' + element.id_product + '" class="id_product"/> <span class="decli-name">' + elementdecli.libelle + '</span><input type="hidden" value="' + elementdecli.id_product_attribute + '" class="id_product_attribute"/></td>';
                            cell_enrouleur = '<td class="rollup">&nbsp;</td>'
                            if (gcof_stock == 1)
                                cell_stock = '<td class="stock">' + elementdecli.quantityavailable + '</td>';

                            if (elementdecli.minimal_quantity > 0)
                                cell_quantity = '<td class="quantity text-center"><div class="product-quantity clearfix"><div class="qty"><input type="text" name="qty" class="quantity_wanted input-group" value="0" min="' + elementdecli.minimal_quantity + '" max="99999"></div></div>';
                            else
                                cell_quantity = '<td class="quantity text-center"><div class="product-quantity clearfix"><div class="qty"><input type="text" name="qty" class="quantity_wanted input-group" value="0" min="0" max="99999"></div></div>';


                            cell_price = '<td class="price">' + elementdecli.price + '</td>';

                            row = '<tr class="item declihidden decliline' + element.id_product + '">';

                            row = row + cell_image;
                            row = row + cell_reference + cell_name + cell_enrouleur;
                            if (gcof_stock == 1)
                                row = row + cell_stock;

                            row = row + cell_quantity + cell_price + '</tr>';

                            var newRow = $(row).clone();
                            $('.orderform_content table tbody').append(newRow);
                        });
                    }

                    BindEnrouleur(newRow.find('.enrouleur'));
                    BindCheckMinimal(newRow.find('.quantity_wanted'));
                });

                if (gcof_quantitybuttons == 1)
                    createProductSpin();
            }
        });
    }
    
    function checkMinimal(myObject) {
		if (parseInt(myObject.val()) == (parseInt(myObject.attr('min'))-1)) {
			myObject.val(0);			
		} else {
			if (parseInt(myObject.val()) < parseInt(myObject.attr('min'))) {
				myObject.val(parseInt(myObject.attr('min')));
			}			
		}
    }

    function hoverIt(myObject) {
        $('.subcategory-image a').each(function () {
            $(this).css('border', '1px solid #d6d4d4');
        });

        if (myObject.hasClass('n2')) {
            myObject.css('border', '1px solid #333333');
        }
        else {
            myObject.parent().css('border', '1px solid #333333');
        }

    }

    function BindCat(myObject) {
        $(myObject).bind("click", function (e) {
            hoverIt(myObject);
        });
    }

    function Refresh(myObject) {
        if (!myObject.hasClass('n2')) {
            refreshProductList(myObject.parent());
        }
        else {
            refreshProductList(myObject);
        }
    }

    function BindRefresh(myObject) {
        $(myObject).bind("click", function (e) {
            Refresh(myObject);
        });
    }

    function BindEnrouleur(myObject) {
        $(myObject).bind('click', function () {
            Enrouleur(myObject);
        });
    }
    
    function BindCheckMinimal(myObject) {
    	$(myObject).bind('change', function() {
        	checkMinimal(myObject);
        });
    }

    function Enrouleur(myObject) {
        var givemeyourid = myObject.attr("id");
        myObject.parent().parent().parent().find('.decliline' + givemeyourid).slideToggle();
        if (myObject.html() == '+') {
            myObject.html('-');
            myObject.css('line-height', '17px');
        }
        else {
            myObject.html('+');
            myObject.css('line-height', '20px');
        }

        return false;
    }

    function createProductSpin() {
        $('.orderform_content tr').each(function () {
            var currentRow = $(this);
            quantityInput = currentRow.find('.quantity_wanted');
            quantityInput.TouchSpin({
                verticalbuttons: true,
                verticalupclass: 'material-icons touchspin-up',
                verticaldownclass: 'material-icons touchspin-down',
                buttondown_class: 'btn btn-touchspin js-touchspin',
                buttonup_class: 'btn btn-touchspin js-touchspin',
                min: 0,
                max: 1000000
            });
        });
    }
	{/literal}
    // ]]>
</script>
