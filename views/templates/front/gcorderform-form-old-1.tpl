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

	{capture name=path}{l s='Order Form' mod='gcorderform'}{/capture}
	<!-- MODULE GcOrderForm -->
	<style>
		.image img:hover {
			width: {$gcof_big_size.width|intval}px;
			height: {$gcof_big_size.height|intval}px;
		}
	</style>
	<div class="orderform_content table-responsive">
		<div id="help_them" class="block">
			<div class="block_content">
				<div class="help_step" id="help_step1">{l s='Select category of your choice' mod='gcorderform'}</div>
				<div class="help_step" id="help_step2">{l s='Fill the order form' mod='gcorderform'}</div>
				<div class="help_step" id="help_step3">{l s='Add your product to cart' mod='gcorderform'}</div>
			</div>
		</div>
		<select id="categories">
			<option value="0">{l s='All categories' mod='gcorderform'}</option>
			{foreach from=$gcof_categories item=categorie}
				<option value="{$categorie.id_category|intval}">{$categorie.name|escape:'html':'UTF-8'}</option>
			{/foreach}
		</select>
		<br/>
		<table class="orderform_table_{$gcof_psversion|escape:'html':'UTF-8'} table table-hover table-striped" cellspacing="0">
			<thead>
			<tr class="head">
				{if $gcof_image == 1}
					<th class="image item">{l s='Image' mod='gcorderform'}</th>
				{/if}
				<th class="ref first_item">{l s='Ref.' mod='gcorderform'}</th>
				<th class="name item">{l s='Name' mod='gcorderform'}</th>
				{if $gcof_stock == 1}
					<th class="stock">{l s='Stock' mod='gcorderform'}</th>
				{/if}
				<th class="quantity item">{l s='Quantity' mod='gcorderform'}</th>
				<th class="price last_item">{l s='Price' mod='gcorderform'}</th>
			</tr>
			</thead>
			<tbody>
			{foreach from=$gcof_products item=product name=myLoop}
				{if !is_array($product.declinaison) && $product.declinaison|substr:0:15 == "ProdSansDecli##"}
					<tr class="item">
						{if $gcof_image == 1}
							<td class="image">
								<img src="{$product.big|escape:'html':'UTF-8'}" alt="{$product.name|escape:'html':'UTF-8'}"
									 width="{$gcof_image_size.width|intval}" height="{$gcof_image_size.height|intval}"/>
							</td>
						{/if}
						<td class="ref"><p class="ref">{$product.reference|escape:'html':'UTF-8'}</p></td>
						<td class="name">
							{if $gcof_link == 1}
								<a href="{$product.link|escape:'html':'UTF-8'}"><span class="title">{$product.name|escape:'html':'UTF-8'}</span></a>
							{else}
								<span class="title">{$product.name|escape:'html':'UTF-8'}</span>
							{/if}
							<input type="hidden" value="{$product.id_product|intval}" class="id_product"/>
							<input type="hidden" value="0" class="id_product_attribute"/>
						</td>
						{if $gcof_stock == 1}
							<td class="stock">{$product.quantityavailable|intval}</td>
						{/if}
						<td class="quantity text-center">
							<input type="text" name="qty" size="4" autocomplete="off" class="form-control grey quantity_wanted text" value="0">
							{if $gcof_quantity_buttons == 1}
								{if $gcof_psversion == '16'}
									<div class="clearfix">
										<a rel="nofollow" class="qtydown btn btn-default button-minus" href="#"
										   title="{l s='Subtract' mod='gcorderform'}">
											<span><i class="icon-minus"></i></span>
										</a>
										<a rel="nofollow" class="qtyup btn btn-default button-plus" href="#"
										   title="{l s='Add' mod='gcorderform'}">
											<span><i class="icon-plus"></i></span>
										</a>
									</div>
								{else}
									<div class="cart_quantity_button">
										<a rel="nofollow" class="qtyup" href="#"><img src="{$gcof_img_dir|escape:'html':'UTF-8'}quantity_up.gif"
																					  alt="{l s='Add' mod='gcorderform'}" width="14"
																					  height="9"></a>
										<a rel="nofollow" class="qtydown" href="#"><img src="{$gcof_img_dir|escape:'html':'UTF-8'}quantity_down.gif"
																						width="14"
																						height="9"
																						alt="{l s='Subtract' mod='gcorderform'}"></a>
									</div>
								{/if}
							{/if}
							<span class="min">{$product.minimal_quantity|intval}</span>
						</td>
						<td class="price">
							{$product.price|escape:'html':'UTF-8'}
						</td>
					</tr>
				{else}
					{foreach from=$product.declinaison item=decli name=myLoop2}
						<tr class="item">
							{if $gcof_image == 1}
								<td class="image">
									<img src="{$decli.big|escape:'html':'UTF-8'}" alt="{$product.name|escape:'html':'UTF-8'}"
										 width="{$gcof_image_size.width|intval}" height="{$gcof_image_size.height|intval}"/>
								</td>
							{/if}
							<td class="ref"><p class="ref">{$decli.reference|escape:'html':'UTF-8'}</p></td>
							<td class="name">
								{if $gcof_link == 1}
									<a href="{$decli.link|escape:'html':'UTF-8'}">
										<span class="title">{$product.name|escape:'html':'UTF-8'}</span>
										<span class="decli-name">{$decli.libelle|escape:'html':'UTF-8'}</span>
									</a>
								{else}
									<span class="title">{$product.name|escape:'html':'UTF-8'}</span>
									<span class="decli-name">{$decli.libelle|escape:'html':'UTF-8'}</span>
								{/if}
								<input type="hidden" value="{$product.id_product|intval}" class="id_product"/>
								<input type="hidden" value="{$decli.id_product_attribute|intval}" class="id_product_attribute"/>
							</td>
							{if $gcof_stock == 1}
								<td class="stock">{$decli.quantityavailable|intval}</td>
							{/if}
							<td class="quantity text-center">
								<input type="text" name="qty" size="4" autocomplete="off" class="form-control grey quantity_wanted text"
									   value="0">
								{if $gcof_quantity_buttons == 1}
									{if $gcof_psversion == '16'}
										<div class="clearfix">
											<a rel="nofollow" class="qtydown btn btn-default button-minus" href="#"
											   title="{l s='Subtract' mod='gcorderform'}">
												<span><i class="icon-minus"></i></span>
											</a>
											<a rel="nofollow" class="qtyup btn btn-default button-plus" href="#"
											   title="{l s='Add' mod='gcorderform'}">
												<span><i class="icon-plus"></i></span>
											</a>
										</div>
									{else}
										<div class="cart_quantity_button">
											<a rel="nofollow" class="qtyup" href="#"><img src="{$gcof_img_dir|escape:'html':'UTF-8'}quantity_up.gif"
																						  alt="{l s='Add' mod='gcorderform'}" width="14"
																						  height="9"></a>
											<a rel="nofollow" class="qtydown" href="#"><img src="{$gcof_img_dir|escape:'html':'UTF-8'}quantity_down.gif"
																							width="14" height="9"
																							alt="{l s='Subtract' mod='gcorderform'}"></a>
										</div>
									{/if}
								{/if}
								<span class="min">{$decli.minimal_quantity|intval}</span>
							</td>
							<td class="price">{$decli.price|escape:'html':'UTF-8'}</td>
						</tr>
					{/foreach}
				{/if}
			{/foreach}
			</tbody>
			<tfoot>
			<tr class="last">
				<td colspan="3" class="add_lines"></td>
				<td colspan="2" class="text-center">
					{if $gcof_psversion == "16"}
						<p id="add_to_cart_fix" class="button btn btn-default button-medium">
							<span>{l s='Add to cart' mod='gcorderform'}<i class="icon-chevron-right right"></i></span>
						</p>
					{else}
						<p id="add_to_cart_fix" class="buttons_bottom_block">
							<input type="submit" name="Submit" value="{l s='Add to cart' mod='gcorderform'}" class="exclusive"/>
						</p>
					{/if}

				</td>
			</tr>
			</tfoot>

		</table>
		<img id="bigpic" style="display: none; visibility: hidden" class="hack156"/>
	</div>
	<script type="text/javascript">
        var gcof_empty = {$gcof_empty|intval};
        var gcof_psversion = '{$gcof_psversion|escape:'html':'UTF-8'}';
        var gcof_stock = {$gcof_stock|intval};
        var gcof_image = {$gcof_image|intval};
    	var gcof_link = {$gcof_link|intval};
		{if $gcof_image}
    	var gcof_image_size_width = {$gcof_image_size.width|intval};
    	var gcof_image_size_height = {$gcof_image_size.height|intval};
		{/if}
        var gcof_img_dir = '{$gcof_img_dir|escape:'html':'UTF-8'}';
        var gcof_url = "{$gcof_url|escape:'html':'UTF-8'}";
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
                                cell_quantity = '<td class="quantity text-center"><input type="text" name="qty" size="4" autocomplete="off" class="form-control grey quantity_wanted text" value="0">';
                                if (gcof_quantitybuttons == 1) {
                                    if (gcof_psversion == '16') {
                                        cell_quantity += '<div class="clearfix" id="quantity_button"><a rel="nofollow" class="qtydown btn btn-default button-minus" href="#" title="Add"><span><i class="icon-minus"></i></span></a><a rel="nofollow" class="qtyup btn btn-default button-plus" href="#" title="Add"><span><i class="icon-plus"></i></span></a></div>';
                                    }
                                    else {
                                        cell_quantity += '<div class="cart_quantity_button"><a rel="nofollow" class="qtyup" href="#"><img src="' + gcof_img_dir + 'quantity_up.gif" width="14" height="9"></a><a rel="nofollow" class="qtydown" href="#"><img src="' + gcof_img_dir + 'quantity_down.gif" width="14" height="9" /></a></div>';
                                    }
                                }
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
                                BindCheckMinimal(newRow.find('.quantity_wanted'));
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
                                    cell_quantity = '<td class="quantity text-center"><input type="text" name="qty" size="4" autocomplete="off" class="form-control grey quantity_wanted text" value="0">';
                                    if (gcof_quantitybuttons == 1) {
                                        if (gcof_psversion == '16') {
                                            cell_quantity += '<div class="clearfix" id="quantity_button"><a rel="nofollow" class="qtydown btn btn-default button-minus" href="#" title="Add"><span><i class="icon-minus"></i></span></a><a rel="nofollow" class="qtyup btn btn-default button-plus" href="#" title="Add"><span><i class="icon-plus"></i></span></a></div>';
                                        }
                                        else {
                                            cell_quantity += '<div class="cart_quantity_button"><a rel="nofollow" class="qtyup" href="#"><img src="' + gcof_img_dir + 'quantity_up.gif" width="14" height="9"></a><a rel="nofollow" class="qtydown" href="#"><img src="' + gcof_img_dir + 'quantity_down.gif" width="14" height="9"></a></div>';
                                        }
                                    }

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
                                    BindCheckMinimal(newRow.find('.quantity_wanted'));
                                });
                            }
                        });
                    }
                });
            });

            $('.qtyup').unbind('click').live('click', function () {
                qtyUp($(this));
                return false;
            });

            $('.qtydown').unbind('click').live('click', function () {
                qtyDown($(this));
                return false;
            });

            $('.quantity_wanted').unbind('keyup').live('keyup', function () {
                checkMinimalQuantityOrderForm($(this));
            });

            $('#add_to_cart_fix').unbind('click').click(function () {
                $('.orderform_content tbody tr').each(function () {
                    if ($(this).find('.quantity input').val() > 0) {
                        var currentRow = $(this);
                        ajaxCart.add(currentRow.find('.name .id_product').val(), currentRow.find('.name .id_product_attribute').val(), false, this, currentRow.find('.quantity input').val(), null);
                        if (gcof_empty == 1)
                            currentRow.find('.quantity input').val("0");
                    }
                });
                return false;
            });
        });

        function checkMinimalQuantityOrderForm(myObject) {
            laligne = myObject.parent();
            if (parseInt($(laligne).find('.quantity_wanted').val()) < parseInt($(laligne).find('.min').text())) {
                $(laligne).find('.quantity_wanted').val("0");
                return false;
            }
            else
                $(laligne).find('.quantity_wanted').css('border', '1px solid #b4b4b4');
            return true;
        }

        function qtyDown(myObject) {
            var laquantiteencours = myObject.parent().parent().find('.quantity_wanted');

            if (parseInt(laquantiteencours.val()) == parseInt(myObject.parent().parent().find('.min').text())) {
                laquantiteencours.val("0");
                laquantiteencours.css('border', '1px solid #b4b4b4');
            }
            else {
                if (laquantiteencours.val() == 0) {
                    laquantiteencours.css('border', '1px solid red');
                }
                else {
                    laquantiteencours.val(parseInt(laquantiteencours.val()) - 1);
                    laquantiteencours.css('border', '1px solid #b4b4b4');
                }

            }
        }

        function qtyUp(myObject) {
            var laquantiteencours = myObject.parent().parent().find('.quantity_wanted');
            if (( laquantiteencours.val() == 0 ) || ( laquantiteencours.val() < parseInt(myObject.parent().parent().find('.min').text()) )) {
                laquantiteencours.val(parseInt(myObject.parent().parent().find('.min').text()))
                laquantiteencours.css('border', '1px solid #b4b4b4');
            }
            else {
                laquantiteencours.val(parseInt(laquantiteencours.val()) + 1);
                laquantiteencours.css('border', '1px solid #b4b4b4');
            }
        }

        function BindCheckMinimal(myObject) {
            $(myObject).bind("keyup", function (e) {
                checkMinimalQuantityOrderForm($(this));
            });
        }
		{/literal}
        // ]]>
	</script>
	<!-- /MODULE GcOrderForm -->
