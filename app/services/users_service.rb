module Services
  class UsersService
    attr_reader :params, :current_user_id

    def initialize(params, current_user_id = nil)
      @params = params
      @current_user_id = current_user_id
    end

    def list
      where_string = params[:key].present? ? "#{params[:key]} LIKE #{params[:input]}" : ""

      if params[:input].class != String && where_string.present? && !params[:input].nil?

        where_string = "#{params[:key]} = #{params[:input]}"
      end

      order_string = params[:order].present? ? "#{params[:order]}" : "last_name"

      User.joins(:profile)
        .select("full_name, username, email, birth_date, graduate_date, employed")
        .where(where_string)
        .order(order_string)
        .paginate(:page => params[:page], :per_page=>params[:limit])
    end

    def create
      raise 'მომხმარებელი არ არის ადმინი' unless user_is_admin?
      user = User.new(user_params)
      user.password = params[:password]
      user.save!
      {success: true}
    rescue => e
      {errs: [e.to_s], has_error: true}
    end

    def update
      if user_is_student? && current_user_id != params[:id]
        raise 'სტუდენტს არ აქვს რედაქტირების უფლება '
      end
      raise 'მომხმარებელი არ არის ადმინი' unless user_is_admin?
      @user = User.find(params[:id])
      @user.update!(user_params)

      {success: true}
    rescue => e
      {errs: [e.to_s], has_error: true}
    end

    def edit
      if user_is_student? && current_user_id != params[:id]
        raise 'სტუდენტს არ აქვს ნახვის უფლება '
      end
      @user = User.find(params[:id])
      @user.as_json(only: [:username, :name, :last_name, :email, :birth_date, :graduate_date, :apply_date],
                            include: {profile: {only: [:name]}})
    rescue => e
      {errs: [e.to_s], has_error: true}
    end

    def destroy
      raise 'მომხმარებელი არ არის ადმინი' unless check_user_admin
      @user = User.find(params[:id])
      @user.destroy!
    rescue => e
      {errs: [e.to_s], has_error: true}
    end

    def send_mail
      UserMailer.new.send_user_info(params)
    rescue => e
      {errs: [e.to_s], has_error: true}
    end

    private

    def user_is_admin?
      User.find(current_user_id).profile.name == 'admin'
    end

    def user_is_student?
      User.find(current_user_id).profile.name == 'student'
    end
    def user_params
      params.require(:user).permit(:username, :email, :password, :profile_id, :name, :last_name, :apply_date,
                                   :graduate_date, :employed)
    end

  end
end
