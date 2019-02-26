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
		<table class="orderform_table_{$gcof_psversion|escape:'html':'UTF-8'} table table-hover" cellspacing="0">
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
								<a href="{$product.link|escape:'html':'UTF-8'}">
									<span class="title">{$product.name|escape:'html':'UTF-8'}</span>
								</a>
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
							<div class="product-quantity clearfix">
								<div class="qty">
									<input
											type="text"
											name="qty"
											class="quantity_wanted input-group"
											value="0"
											min="0"
											max="99999"
									>
								</div>
							</div>
							<span class="min"></span>
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
									<a href="{$decli.link|escape:'html':'UTF-8'}"><span class="title">{$product.name|escape:'html':'UTF-8'}</span>
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
