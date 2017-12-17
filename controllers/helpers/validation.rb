module Validation
  def validates(&block)
    schema = Dry::Validation.Schema(&block)
    validation = schema.call(params)
    raise HTTPError::BadRequest if validation.failure?
  end
end
