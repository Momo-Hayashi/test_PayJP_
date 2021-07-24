class CardsController < ApplicationController
  require "payjp"
  before_action :authenticate_user!, only: [:new, :create]

  def new
  end

  def create
    Payjp.api_key = ENV["PAYJP_SECRET_KEY"]
    # ここでテスト鍵をセットしてあげる(環境変数にしても良い)
    if params['payjp-token'].blank?
      redirect_to action: "new"
    else
      # トークンが正常に発行されていたら、顧客情報をPAY.JPに登録します。
      customer = Payjp::Customer.create(
        description: 'test', # 無くてもOK。PAY.JPの顧客情報に表示する概要です。
        email: current_user.email,
        card: params['payjp-token'], # 直前のnewアクションで発行され、送られてくるトークンをここで顧客に紐付けて永久保存します。
        metadata: {user_id: current_user.id} # 無くてもOK。
      )
      @card = Card.new(user_id: current_user.id, customer_id: customer.id, card_id: customer.default_card)
      if @card.save
        redirect_to action: "index"
      else
        redirect_to action: "create"
      end
    end
    # Payjp.api_key = ENV["PAYJP_SECRET_KEY"]
    # customer = Payjp::Customer.create(
    #   description: 'test',
    #   card: params[:token_id]
    # )
    #
    # card = Card.new(
    #   customer_id: customer.id,
    #   token_id: params[:token_id],
    #   user_id: current_user.id
    # )
    #
    # if card.save
    #   redirect_to root_path
    # else
    #   redirect_to new_card_path
    # end

  end

end
