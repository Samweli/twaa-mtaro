class MapObjectMailer < ActionMailer::Base
  default :from => "chicagoshovels@cityofchicago.org"

  def reminder(map_object)
    @map_object = map_object
    @user = map_object.user
    mail(
      {
        :to => map_object.user.email,
        :subject => ["Remember to shovel", map_object.name].compact.join(' '),
      }
    )
  end
end
