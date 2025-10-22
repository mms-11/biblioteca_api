class GraphqlController < ApplicationController
  skip_before_action :authenticate_user!, only: [:execute] # permite queries públicas que o scope liberar

  def execute
    result = BibliotecaApiSchema.execute(
      params[:query],
      variables: ensure_hash(params[:variables]),
      context: { current_user: current_user },
      operation_name: params[:operationName]
    )
    render json: result
  end

  private

  def ensure_hash(ambiguous_param)
    case ambiguous_param
    when String then ambiguous_param.present? ? JSON.parse(ambiguous_param) : {}
    when Hash, ActionController::Parameters then ambiguous_param
    else {}
    end
  end
end
