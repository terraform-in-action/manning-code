package petstore

import (
	"net/url"

	"github.com/hashicorp/terraform-plugin-sdk/helper/schema"
	"github.com/hashicorp/terraform-plugin-sdk/terraform"
	sdk "github.com/scottwinkler/go-petstore"
)

func Provider() terraform.ResourceProvider {
	return &schema.Provider{
		Schema: map[string]*schema.Schema{
			"address": &schema.Schema{
				Type:        schema.TypeString,
				Optional:    true,
				DefaultFunc: schema.EnvDefaultFunc("PETSTORE_ADDRESS", nil),
			},
		},
		ResourcesMap: map[string]*schema.Resource{
			"petstore_pet": resourcePSPet(),
		},
		ConfigureFunc: providerConfigure,
	}
}

func providerConfigure(d *schema.ResourceData) (interface{}, error) {
	hostname, _ := d.Get("address").(string)
	address, _ := url.Parse(hostname)
	cfg := &sdk.Config{
		Address: address.String(),
	}
	return sdk.NewClient(cfg)
}
