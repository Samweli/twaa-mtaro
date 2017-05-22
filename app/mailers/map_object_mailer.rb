class MapObjectMailer < ActionMailer::Base
  default :from => "twaamtaro@gmail.com"

  def reminder(map_object)
    @map_object = map_object
    @user = map_object.user
    mail(
      {
        :to => map_object.user.email,
        :subject => ["Remember to clean", map_object.name].compact.join(' '),
      }
    )
  end
end
