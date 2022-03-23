module UserServices
  class Create
    def initialize(user_params)
      user_params = user_params[:user_params]
      @email = user_params['email']
      @password = user_params['password']
      @name = user_params['name']
      @surname = user_params['surname']
    end

    def call
      user_create
    end

    private

    attr_reader :email, :password, :name, :surname

    def user_create
      ::User.new.tap do |u|
        u.email = email
        u.password = password
        u.name = name
        u.surname = surname
        u.save
      end
    end
  end
end
