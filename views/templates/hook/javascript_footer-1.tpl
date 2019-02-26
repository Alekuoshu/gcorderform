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
    var gcof_stock = {$gcof_stock|intval};
    var gcof_image = {$gcof_image|intval};
    var gcof_link = {$gcof_link|intval};
	{if $gcof_image}
    var gcof_image_size_width = {$gcof_image_size.width|intval};
    var gcof_image_size_height = {$gcof_image_size.height|intval};
	{/if}
    var gcof_url = "{$gcof_url|escape:'html':'UTF-8'}";
    var gcof_cart_url = "{$cart_url|escape:'html':'UTF-8'}";
    var gcof_quantitybuttons = {$gcof_quantity_buttons|intval};

    // <![CDATA[
	{literal}
    $(document).ready(function () {
        $('#categories').change(function () {
            $.ajax({
                url: gcof_url,
                type: "GET",
                dataType: 'json',
                data: "id_category=" + $('#categories').val(),
                success: function (data) {
                    var cell_image, cell_reference, cell_name, cell_decli, cell_stock, cell_quantity, cell_price, row;
                    $('.orderform_content table tbody tr').remove();
                    $.each(data, function (index, element) {
                        if ((!$.isArray(element.declinaison)) && (element.declinaison.substr(0, 15) == "ProdSansDecli##")) {
                            if (gcof_image == 1)
                                cell_image = '<td class="image"><img src="' + element.big + '" alt="' + element.name + '" width="' + gcof_image_size_width + '" height="' + gcof_image_size_height + '" /></td>';

                            cell_reference = '<td class="ref"><p class="ref">' + element.reference + '</p></td>';
                            if (gcof_link == 1)
                                cell_name = '<td class="name"><a href="' + element.link + '"><span class="title">' + element.name + '</span></a>';
                            else
                                cell_name = '<td class="name"><span class="title">' + element.name + '</span>';
                            cell_name += '<input type="hidden" value="' + element.id_product + '" class="id_product"/><input type="hidden" value="0" class="id_product_attribute"/></td>';
                            if (gcof_stock == 1)
                                cell_stock = '<td class="stock">' + element.quantityavailable + '</td>';
                            if (element.minimal_quantity > 0)
                                cell_quantity = '<td class="quantity text-center"><div class="product-quantity clearfix"><div class="qty"><input type="text" name="qty" class="quantity_wanted input-group" value="0" min="' + element.minimal_quantity + '" max="99999"></div></div>';
                            else
                                cell_quantity = '<td class="quantity text-center"><div class="product-quantity clearfix"><div class="qty"><input type="text" name="qty" class="quantity_wanted input-group" value="0" min="0" max="99999"></div></div>';

                            cell_quantity += '<span class="min">' + element.minimal_quantity + '</span></td>';
                            cell_price = '<td class="price">' + element.price + '</td>';

                            row = '<tr class="item">';

                            if (gcof_image == 1)
                                row = row + cell_image;

                            row = row + cell_reference + cell_name;
                            if (gcof_stock == 1)
                                row = row + cell_stock;

                            row = row + cell_quantity + cell_price + '</tr>';

                            var newRow = $(row).clone();
                            $('.orderform_content table tbody').append(newRow);
                        } else {
                            $.each(element.declinaison, function (index2, elementdecli) {
                                if (gcof_image == 1)
                                    cell_image = '<td class="image"><img src="' + elementdecli.big + '" alt="' + element.name + '" width="' + gcof_image_size_width + '" height="' + gcof_image_size_height + '" /></td>';

                                cell_reference = '<td class="ref"><p class="ref">' + elementdecli.reference + '</p></td>';
                                if (gcof_link == 1)
                                    cell_name = '<td class="name"><a href="' + elementdecli.link + '"><span class="title">' + element.name + '</span> <span class="decli-name">' + elementdecli.libelle + '</span></a>';
                                else
                                    cell_name = '<td class="name"><span class="title">' + element.name + '</span> <span class="decli-name">' + elementdecli.libelle + '</span>';
                                cell_name += '<input type="hidden" value="' + element.id_product + '" class="id_product"/><input type="hidden" value="' + elementdecli.id_product_attribute + '" class="id_product_attribute"/></td>';
                                if (gcof_stock == 1)
                                    cell_stock = '<td class="stock">' + elementdecli.quantityavailable + '</td>';
                                if (elementdecli.minimal_quantity > 0)
                                    cell_quantity = '<td class="quantity text-center"><div class="product-quantity clearfix"><div class="qty"><input type="text" name="qty" class="quantity_wanted input-group" value="0" min="' + elementdecli.minimal_quantity + '" max="99999"></div></div>';
                                else
                                    cell_quantity = '<td class="quantity text-center"><div class="product-quantity clearfix"><div class="qty"><input type="text" name="qty" class="quantity_wanted input-group" value="0" min="0" max="99999"></div></div>';

                                cell_quantity += '<span class="min">' + elementdecli.minimal_quantity + '</span></td>';
                                cell_price = '<td class="price">' + elementdecli.price + '</td>';

                                row = '<tr class="item">';

                                if (gcof_image == 1)
                                    row = row + cell_image;

                                row = row + cell_reference + cell_name;
                                if (gcof_stock == 1)
                                    row = row + cell_stock;

                                row = row + cell_quantity + cell_price + '</tr>';

                                var newRow = $(row).clone();
                                $('.orderform_content table tbody').prepend(newRow);
                            });
                        }
                    });
                    if (gcof_quantitybuttons == 1)
                        createProductSpin();
                }
            });
        });

        $('#add_to_cart_fix').unbind('click').click(function () {
            $('.orderform_content tbody tr').each(function () {
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
        if (gcof_quantitybuttons == 1)
            createProductSpin();
    });

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
