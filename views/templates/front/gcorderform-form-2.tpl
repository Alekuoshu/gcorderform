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

{extends file='page.tpl'}
{block name='page_content'}

	{capture name=path}{l s='Order Form' mod='gcorderform'}{/capture}
	<!-- MODULE GcOrderForm -->
	<div class="orderform_content table-responsive">
		<div id="ofsubcategories">
			<ul class="clearfix">
				{foreach from=$gcof_categories item=categorie}
					<li>
						<div class="subcategory-image">
							<a rel='{$categorie.id_category|intval}' title='{$categorie.name|escape:'html':'UTF-8'}' class='img filter'>
								<img class="replace-2x catimage filter"
									 src="{$link->getCatImageLink($categorie.link_rewrite, $categorie.id_category, 'order_form_cat_default')|escape:'html':'UTF-8'}"
									 alt="{$categorie.name|escape:'html':'UTF-8'}" width="{$gcof_cat_size.width|intval}"
									 height="{$gcof_cat_size.height|intval}"/></a>
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
		<table class="orderform_table_{$gcof_psversion|escape:'html':'UTF-8'} table table-hover" width="100%" border="0" cellspacing="0" cellpadding="0">
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
							{if $gcof_link == 1}
								<a class="product_img_link" href="{$product.link|escape:'html':'UTF-8'}" title="{$product.name|escape:'html':'UTF-8'}" itemprop="url">
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
							<div class="product-quantity clearfix">
								<div class="qty">
									{if $product.minimal_quantity|intval > 0}
										<input
												type="text"
												name="qty"
												class="quantity_wanted input-group"
												value="0"
												min="{$product.minimal_quantity|intval}"
												max="99999"
										>
									{else}
										<input
												type="text"
												name="qty"
												class="quantity_wanted input-group"
												value="0"
												min="0"
												max="99999"
										>
									{/if}
								</div>
							</div>
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
							{if $gcof_link == 1}
								<a class="product_img_link" href="{$product.link|escape:'html':'UTF-8'}" title="{$product.name|escape:'html':'UTF-8'}" itemprop="url">
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
								{if $gcof_link == 1}
									<a class="product_img_link" href="{$decli.link|escape:'html':'UTF-8'}" title="{$product.name|escape:'html':'UTF-8'}" itemprop="url">
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
								<div class="product-quantity clearfix">
									<div class="qty">
										{if $decli.minimal_quantity|intval > 0}
											<input
													type="text"
													name="qty"
													class="quantity_wanted input-group"
													value="0"
													min="{$decli.minimal_quantity|intval}"
													max="99999"
											>
										{else}
											<input
													type="text"
													name="qty"
													class="quantity_wanted input-group"
													value="0"
													min="0"
													max="99999"
											>
										{/if}
									</div>
								</div>
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
				<td colspan="3" class="text-center">
					<button id="add_to_cart_fix" class="btn btn-primary" data-button-action="add-to-cart"><i
								class="material-icons">&#xE547;</i>{l s='Add to cart' mod='gcorderform'}</button>
				</td>
			</tr>
			</tfoot>

		</table>
		<img id="bigpic" class="hack156"/>
	</div>
	<!-- /MODULE GcOrderForm -->
{/block}
