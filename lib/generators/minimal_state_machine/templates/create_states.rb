class CreateStates < ActiveRecord::Migration
  def change
    create_table :msm_states do |t|
      t.string :type
      t.references :state_machine, :polymorphic => true  
      t.timestamps
    end
  end
end