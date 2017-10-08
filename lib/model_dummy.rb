class ModelDummy
  def self.dummy
    OpenStruct.new(model_name: OpenStruct.new(param_key: 'file'))
  end
end