func resourcePSPetUpdate(d *schema.ResourceData, meta interface{}) error {
	conn := meta.(*sdk.Client)
	options := sdk.PetUpdateOptions{}
	if d.HasChange("name") {
		options.Name = d.Get("name").(string)
	}
	if d.HasChange("age") {
		options.Age = d.Get("age").(int)
	}
	conn.Pets.Update(d.Id(), options)
	return resourcePSPetRead(d, meta)
}

func resourcePSPetDelete(d *schema.ResourceData, meta interface{}) error {
	conn := meta.(*sdk.Client)
	err := conn.Pets.Delete(d.Id())
	if err != nil {
		return err
	}
	return nil
}
