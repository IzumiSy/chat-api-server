module Validation
  def validates(&block)
    schema = Class.new(Dry::Validation::Contract, &block).new
    validation = schema.call(params)
    raise HTTPError::BadRequest if validation.failure?
  end
end
