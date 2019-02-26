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

<div id="gcorderform_block_left">
	<h4 class="text-uppercase h6 hidden-sm-down">{l s='Order quicker !' mod='gcorderform'}</h4>
	<div class="block_content gcorderform_block">
		<p class="quickorder_image">
			<a href="{$link->getModuleLink('gcorderform')|escape:'html':'UTF-8'}" title="{l s='Go to Order Form' mod='gcorderform'}"><img
						src="{$gcof_picture|escape:'html':'UTF-8'}"
						alt="{l s='Order quicker !' mod='gcorderform'}"
						title="{l s='Order quicker !' mod='gcorderform'}"
						width="155" height="163"
						class="img-responsive"/></a>
		</p>
	</div>
</div>
