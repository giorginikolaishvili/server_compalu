module Services
  class UsersService
    attr_reader :params, :current_user_id

    def initialize(params, current_user_id = nil)
      @params = params
      @current_user_id = current_user_id
    end

    def list
      where_string = ""
      where_string += " AND full_name LIKE '%#{params[:input]}%'" if params[:input].present?
      where_string += " AND employed = #{params[:is_employed]}" unless params[:is_employed].nil?
      where_string += " AND apply_date >= :start_date" unless params[:start_date].nil?
      where_string += " AND graduate_date <= :end_date" unless params[:end_date].nil?
      order_string = "#{params[:property]} #{params[:direction]} "
      arr = User.joins(:profile)
                .select("users.id, full_name, email, birth_date, graduate_date, apply_date, employed, created_at,
                 users.name, last_name, hobby, profile_id, profiles.name as profile_name")
                .where("1 = 1" + where_string, start_date: params[:start_date]&.to_date, end_date: params[:end_date]&.to_date)
                .order(order_string)
                .paginate(:page => params[:page], :per_page => params[:limit])

      {
          users: arr,
          length: arr.length,
          page: params[:page],
          limit: params[:limit]
      }
    end

    def create
      raise 'მომხმარებელი არ არის ადმინი' unless user_is_admin?
      user = User.new(user_params)
      user.password = (0...12).map {('a'..'z').to_a[rand(26)]}.join

      user.save!

      mail_params = {ids: [user.id], subject: 'სტუდენტთა ბაზის პაროლი',
                     body: "მომხმარებელი #{user.email} წარმატებით დარეგისტრირდა სტუდენტთა ბაზაში, დაგენერირებული პაროლი: #{user.password}"}
      UserMailer.new.send_user_info(mail_params)

      {success: true}
    rescue => e
      {errs: [e.to_s], has_error: true}
    end

    def update
      if user_is_student? && current_user_id != params[:id]
        raise 'სტუდენტს არ აქვს რედაქტირების უფლება '
      end

      @user = User.find(params[:id])
      @user.update!(user_params)

      {success: true}
    rescue => e
      {errs: [e.to_s], has_error: true}
    end

    def edit
      if user_is_student? && current_user_id != params[:id].to_i
        raise 'სტუდენტს არ აქვს ნახვის უფლება '
      end
      @user = User.find(params[:id])
      @user.as_json(except: [:password_digest],
                    include: {profile: {only: [:id, :name]},
                              user_portfolios: {only: [:description, :company_name,
                                                       :id, :start_date, :end_date, :job_title]}})
    rescue => e
      {errs: [e.to_s], has_error: true}
    end

    def check_user_admin
      User.find(@current_user_id).profile.name == 'admin'
    end

    def destroy
      raise 'მომხმარებელი არ არის ადმინი' unless check_user_admin
      @user = User.find(params[:id])
      @user.destroy!
    rescue => e
      {errs: [e.to_s], has_error: true}
    end

    def password_reset
      @user = User.find(params[:id])

      raise 'ძველი პაროლი არასწორია' unless @user.authenticate(params[:old_password])
      @user.password = params[:new_password]
      @user.save!

      {success: true}
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
      params.require(:user).permit(:email, :password, :profile_id, :name, :last_name, :apply_date,
                                   :graduate_date, :employed, :hobby, :birth_date, :image_base64,
                                   user_portfolios_attributes: [:id, :description, :start_date, :end_date, :company_name,
                                                                :job_title, :_destroy])
    end

  end
end
