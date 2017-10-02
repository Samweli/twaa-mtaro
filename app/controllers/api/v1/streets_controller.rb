class Api::V1::StreetsController < Api::V1::BaseController

  def index
    streets = Street.all

    render(
        json: ActiveModel::ArraySerializer.new(
                                              streets,
                                              each_serializer: Api::V1::StreetSerializer,
                                              root: 'streets'
        )
    )

  end
end