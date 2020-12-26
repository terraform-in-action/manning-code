func resourcePSPetRead(d *schema.ResourceData, meta interface{}) error {
	conn := meta.(*sdk.Client)
	pet, err := conn.Pets.Read(d.Id())
	if err != nil {
		return err
	}
	d.Set("name", pet.Name)
	d.Set("species", pet.Species)
	d.Set("age", pet.Age)
	return nil
}

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
