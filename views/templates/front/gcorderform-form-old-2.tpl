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
<div class="orderform_content table-responsive">
	<div id="ofsubcategories">
		<ul class="clearfix">
			{foreach from=$gcof_categories item=categorie}
				<li>
					<div class="subcategory-image">
						<a rel='{$categorie.id_category|intval}' title='{$categorie.name|escape:'html':'UTF-8'}' class='img filter'>
							<img class="replace-2x catimage"
								 src="{$link->getCatImageLink($categorie.link_rewrite, $categorie.id_category, 'order_form_cat_default')|escape:'html':'UTF-8'}"
								 alt="{$categorie.name|escape:'html':'UTF-8'}" width="{$gcof_cat_size.width|intval}" height="{$gcof_cat_size.height|intval}"/></a>
						</a>
					</div>
					<h5 class="subcategory-name">{$categorie.name|escape:'html':'UTF-8'}</h5>
				</li>
			{/foreach}
		</ul>
	</div>
	<br/>

	<div id="ofsubcategoriesn2" class="clearfix">
	<span class="texte">
		{l s='Subcategories of' mod='gcorderform'}<br/>
		<span class="cat">something</span>
	</span>
		<ul class="clearfix">
		</ul>
	</div>
	<br/>
	<table class="orderform_table_{$gcof_psversion|escape:'html':'UTF-8'} table table-hover table-striped" width="100%" border="0" cellspacing="0" cellpadding="0">
		<thead>
		<tr class="head">
			{if $gcof_image == 1}
				<th class="image first_item">{l s='Image' mod='gcorderform'}</th>
			{/if}
			<th class="ref item">{l s='Ref.' mod='gcorderform'}</th>
			<th class="name item">{l s='Name' mod='gcorderform'}</th>
			<th class="thenrouleur item">{l s='Products combination' mod='gcorderform'}</th>
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
							{if $product.big != ''}
								<a href="{$product.big|escape:'html':'UTF-8'}"
								   data-lightbox="{$product.name|escape:'html':'UTF-8'}{$product.id_product|intval}"
								   data-title="{$product.name|escape:'html':'UTF-8'}" title="{$product.name|escape:'html':'UTF-8'}">
									<img src="{$product.big|escape:'html':'UTF-8'}" alt="{$product.name|escape:'html':'UTF-8'}"
										 width="{$gcof_image_size.width|intval}" height="{$gcof_image_size.height|intval}"/>
								</a>
							{/if}
						</td>
					{/if}
					<td class="ref"><p class="ref">{$product.reference|escape:'html':'UTF-8'}</p></td>
					<td class="name">
						{if $gcof_link}
							<a class="product_img_link" href="{$product.link|escape:'html':'UTF-8'}" title="{$product.name|escape:'html':'UTF-8'}"
							   itemprop="url">
								<span class="title">{$product.name|escape:'html':'UTF-8'}</span>
							</a>
						{else}
							<span class="title">{$product.name|escape:'html':'UTF-8'}</span>
						{/if}
						<input type="hidden" value="{$product.id_product|intval}" class="id_product"/>
						<input type="hidden" value="0" class="id_product_attribute"/>
					</td>
					<td>&nbsp;</td>
					{if $gcof_stock == 1}
						<td class="stock">{$product.quantityavailable|intval}</td>
					{/if}
					<td class="quantity text-center">
						<input type="text" name="qty" size="4" autocomplete="off" class="form-control grey quantity_wanted text" value="0">
						{if $gcof_quantity_buttons == 1}
							{if $gcof_psversion == '16'}
								<div class="clearfix" id="quantity_button">
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
					<td class="price">{$product.price|escape:'html':'UTF-8'}</td>
				</tr>
			{else}
				<tr class="item">
					{if $gcof_image == 1}
						<td class="image">
							{if $product.big != ''}
								<a href="{$product.big|escape:'html':'UTF-8'}"
								   data-lightbox="{$product.name|escape:'html':'UTF-8'}{$product.id_product|intval}"
								   data-title="{$product.name|escape:'html':'UTF-8'}" title="{$product.name|escape:'html':'UTF-8'}">
									<img src="{$product.big|escape:'html':'UTF-8'}" alt="{$product.name|escape:'html':'UTF-8'}"
										 width="{$gcof_image_size.width|intval}" height="{$gcof_image_size.height|intval}"/>
								</a>
							{/if}
						</td>
					{/if}
					<td class="ref"><p class="ref"></p></td>
					<td class="name">
						{if $gcof_link}
							<a class="product_img_link" href="{$product.link|escape:'html':'UTF-8'}" title="{$product.name|escape:'html':'UTF-8'}"
							   itemprop="url">
								<span class="title">{$product.name|escape:'html':'UTF-8'}</span>
							</a>
						{else}
							<span class="title">{$product.name|escape:'html':'UTF-8'}</span>
						{/if}

						<input type="hidden" value="{$product.id_product|intval}" class="id_product"/>
						<input type="hidden" value="0" class="id_product_attribute"/>
					</td>
					<td class="rollup"><span class="enrouleur" id="{$product.id_product|intval}">+</span></td>
					{if $gcof_stock == 1}
						<td class="stock"></td>
					{/if}
					<td class="quantity text-center">

					</td>
					<td class="price"></td>
				</tr>
				{foreach from=$product.declinaison item=decli name=myLoop2}
					<tr class="item declihidden decliline{$product.id_product|intval}">
						{if $gcof_image == 1}
							<td class="image">
								{if $decli.big != ''}
									<a href="{$decli.big|escape:'html':'UTF-8'}"
									   data-lightbox="{$product.name|escape:'html':'UTF-8'} {$decli.libelle|escape:'html':'UTF-8'}{$decli.id_product_attribute|intval}"
									   data-title="{$product.name|escape:'html':'UTF-8'} {$decli.libelle|escape:'html':'UTF-8'}"
									   title="{$product.name|escape:'html':'UTF-8'} {$decli.libelle|escape:'html':'UTF-8'}">
										<img src="{$decli.big|escape:'html':'UTF-8'}" alt="{$product.name|escape:'html':'UTF-8'}"
											 width="{$gcof_image_size.width|intval}" height="{$gcof_image_size.height|intval}"/>
									</a>
								{/if}
							</td>
						{/if}
						<td class="ref"><p class="ref">{$decli.reference|escape:'html':'UTF-8'}</p></td>
						<td class="name">
							{if $gcof_link}
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
						<td>&nbsp;</td>
						{if $gcof_stock == 1}
							<td class="stock">{$decli.quantityavailable|intval}</td>
						{/if}
						<td class="quantity text-center">
							<input type="text" name="qty" size="4" autocomplete="off" class="form-control grey quantity_wanted text"
								   value="0">
							{if $gcof_quantity_buttons == 1}
								{if $gcof_psversion == '16'}
									<div class="clearfix" id="quantity_button">
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
			<td colspan="4" class="text-center">
				{if $gcof_psversion == '16'}
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
	{if $gcof_image}
    var image_size_width = {$gcof_image_size.width|intval};
    var image_size_height = {$gcof_image_size.height|intval};
	{/if}
    var gcof_img_dir = '{$gcof_img_dir|escape:'html':'UTF-8'}';
    var gcof_url = '{$link->getModuleLink('gcorderform', 'actions', ['process' => 'get'], {$gcof_ssl|intval})|escape:'html':'UTF-8'}';
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
                    displaySubCategories($(this));
                }

                if (!$(this).hasClass('n2')) {
                    refreshProductList($(this));
                }
                else {
                    refreshProductList($(this));
            	}
            }

            return false;
        });

        $('.name').unbind('click').on('click', '.product_img_link', function () {
            checkFormFill();
            return true;
        });

        $('.qtyup').unbind('click').live('click', function () {
            qtyUp($(this));
            return false;
        });

        $('.qtydown').unbind('click').live('click', function () {
            qtyDown($(this));
            return false;
        });

        $('.quantity_wanted').unbind('focusout').live('focusout', function () {
            checkMinimalQuantityOrderForm($(this));
        });

        $('#add_to_cart_fix').unbind('click').click(function () {
            $('tbody tr').each(function () {
                if ($(this).find('.quantity_wanted').val() > 0) {
                    var currentRow = $(this);
                    ajaxCart.add(currentRow.find('.name .id_product').val(), currentRow.find('.name .id_product_attribute').val(), false, this, currentRow.find('.quantity input').val(), null);
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
                        ajaxCart.add(currentRow.find('.name .id_product').val(), currentRow.find('.name .id_product_attribute').val(), false, this, currentRow.find('.quantity input').val(), null);
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
                        }
                        cell_reference = '<td class="ref"><p class="ref">' + element.reference + '</p></td>';
                        cell_name = '<td class="name"><a class="product_img_link" href="' + element.link + '" title="' + element.name + '"><span class="title">' + element.name + '</span><input type="hidden" value="' + element.id_product + '" class="id_product"/></a><input type="hidden" value="0" class="id_product_attribute"/></td>';
                        cell_enrouleur = '<td class="rollup">&nbsp;</td>'
                        if (gcof_stock == 1)
                            cell_stock = '<td class="stock">' + element.quantityavailable + '</td>';

                        cell_quantity = '<td class="quantity text-center"><input type="text" name="qty" size="4" autocomplete="off" class="form-control grey quantity_wanted text" value="0">';

                        if (gcof_quantitybuttons == 1) {
                            if (gcof_psversion == '16') {
                                cell_quantity += '<div ' +
                                    'class="clearfix" id="quantity_button"><a rel="nofollow" class="qtydown btn btn-default ' +
                                    'button-minus" href="#" title="Add"><span><i class="icon-minus"></i></span></a><a ' +
                                    'rel="nofollow" class="qtyup btn btn-default button-plus" href="#" title="Add"><span><i ' +
                                    'class="icon-plus"></i></span></a></div>';
                            }
                            else {
                                cell_quantity += '<div ' +
                                    'class="cart_quantity_button"><a rel="nofollow" class="qtyup" href="#"><img ' +
                                    'src="' + gcof_img_dir + 'quantity_up.gif" width="14" height="9"></a><a rel="nofollow" ' +
                                    'class="qtydown" href="#"> <img src="' + gcof_img_dir + 'quantity_down.gif" width="14" height="9" ' +
                                    '/> </a></div>';
                            }
                        }

                        cell_quantity += '<span class="min">' + element.minimal_quantity + '</span></td>';

                        cell_price = '<td class="price">' + element.price + '</td>';

                        row = '<tr class="item">';
                        if (gcof_image == 1)
                            row = row + cell_image;
                        row = row + cell_reference + cell_name + cell_enrouleur;
                        if (gcof_stock == 1)
                            row = row + cell_stock;

                        row = row + cell_quantity + cell_price + '</tr>';

                        var newRow = $(row).clone();
                        $('.orderform_content table tbody').append(newRow);
                        BindCheckMinimal(newRow.find('.quantity_wanted'));
                    } else {

                        if (gcof_image == 1) {
                            if (typeof element.big != "undefined")
                                cell_image = '<td class="image"><a href="' + element.big + '" data-lightbox="' + element.name + element.id_product + '" data-title="' + element.name + '" title="' + element.name + '"><img src="' + element.big + '" alt="' + element.name + '" width="' + image_size_width + '" height="' + image_size_height + '" /></a></td>';
                            else
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

                        if (gcof_image == 1)
                            row = row + cell_image;
                        row = row + cell_reference + cell_name + cell_enrouleur;
                        if (gcof_stock == 1)
                            row = row + cell_stock;

                        row = row + cell_quantity + cell_price + '</tr>';

                        var newRow = $(row).clone();
                        $('.orderform_content table tbody').append(newRow);
                        BindCheckMinimal(newRow.find('.quantity_wanted'));
                        $.each(element.declinaison, function (index2, elementdecli) {
                            if (gcof_image == 1) {
                                if (typeof elementdecli.big != "undefined")
                                    cell_image = '<td class="image"><a href="' + elementdecli.big + '" data-lightbox="' + element.name + element.id_product + ' ' + elementdecli.libelle + '" data-title="' + element.name + ' ' + elementdecli.libelle + '" title="' + element.name + ' ' + elementdecli.libelle + '"><img src="' + elementdecli.big + '#" alt="' + element.name + '" width="' + image_size_width + '" height="' + image_size_height + '" /></a></td>';
                                else
                                    cell_image = '<td class="image"></td>';
                            }
                            cell_reference = '<td class="ref"><p class="ref">' + elementdecli.reference + '</p></td>';
                            cell_name = '<td class="name"><span class="title">' + element.name + '</span><input type="hidden" value="' + element.id_product + '" class="id_product"/> <span class="decli-name">' + elementdecli.libelle + '</span><input type="hidden" value="' + elementdecli.id_product_attribute + '" class="id_product_attribute"/></td>';
                            cell_enrouleur = '<td class="rollup">&nbsp;</td>'
                            if (gcof_stock == 1)
                                cell_stock = '<td class="stock">' + elementdecli.quantityavailable + '</td>';

                            cell_quantity = '<td class="quantity text-center"><input type="text" name="qty" size="4" autocomplete="off" class="form-control grey quantity_wanted text" value="0">';
                            if (gcof_quantitybuttons == 1) {
                                if (gcof_psversion == '16') {
                                    cell_quantity += '<div ' +
                                        'class="clearfix" id="quantity_button"><a rel="nofollow" class="qtydown btn btn-default ' +
                                        'button-minus" href="#" title="Add"><span><i class="icon-minus"></i></span></a><a ' +
                                        'rel="nofollow" class="qtyup btn btn-default button-plus" href="#" title="Add"><span><i ' +
                                        'class="icon-plus"></i></span></a></div>';
                                }
                                else {
                                    cell_quantity += '<div ' +
                                        'class="cart_quantity_button"><a rel="nofollow" class="qtyup" href="#"><img ' +
                                        'src="' + gcof_img_dir + 'quantity_up.gif" width="14" height="9"></a><a rel="nofollow" ' +
                                        'class="qtydown" href="#"><img src="' + gcof_img_dir + 'quantity_down.gif" width="14" ' +
                                        'height="9"></a></div>';
                                }
                            }

                            cell_quantity += '<span class="min">' + elementdecli.minimal_quantity + '</span></td>';

                            cell_price = '<td class="price">' + elementdecli.price + '</td>';

                            row = '<tr class="item declihidden decliline' + element.id_product + '">';

                            if (gcof_image == 1)
                                row = row + cell_image;
                            row = row + cell_reference + cell_name + cell_enrouleur;
                            if (gcof_stock == 1)
                                row = row + cell_stock;

                            row = row + cell_quantity + cell_price + '</tr>';

                            var newRow = $(row).clone();
                            $('.orderform_content table tbody').append(newRow);
                            BindCheckMinimal(newRow.find('.quantity_wanted'));
                        });
                    }

                    BindEnrouleur(newRow.find('.enrouleur'));
                });
            }
        });
    }

    function hoverIt(myObject) {
        $('.subcategory-image').each(function () {
            $(this).css('border', '1px solid #d6d4d4');
        });
        if (myObject.hasClass('n2')) {
            myObject.parent().css('border', '1px solid #333333');
        }
        else {
            myObject.parent().css('border', '1px solid #333333');
        }

    }

    function qtyUp(myObject) {
        var laquantiteencours = myObject.parent().parent().find('.quantity_wanted');
        var lemin = parseInt(myObject.parent().parent().find('.min').text());
        if (lemin > 1) {
			if (laquantiteencours.val() > 0) {
				laquantiteencours.val(parseInt(laquantiteencours.val()) + 1);
			} else {
				laquantiteencours.val(lemin);
			}
        } else {
	        laquantiteencours.val(parseInt(laquantiteencours.val()) + 1);
        }
        laquantiteencours.css('border', '1px solid #b4b4b4');
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

    function BindCheckMinimal(myObject) {
        $(myObject).bind("focusout", function (e) {
            checkMinimalQuantityOrderForm($(this));
        });
    }

    function BindCat(myObject) {
        $(myObject).bind("click", function (e) {
            hoverIt($(this));
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

	{/literal}
    // ]]>
</script>
<!-- /MODULE GcOrderForm -->
