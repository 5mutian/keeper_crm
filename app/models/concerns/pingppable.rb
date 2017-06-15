
module Pingppable
  extend ActiveSupport::Concern

   class_methods do
     #查询所有交易
     def pingpp_query_all(options={})
       options = {limit: 10, starting_after: nil, ending_before: nil, created: nil, channel: nil, paid: true, refunded: false}.merge(options).compact
       Pingpp::Charge.all(options)
     end
   end

   #支付
  def pingpp_charge(pay_orders={})
    charge = Pingpp::Charge.create({:app => {"id" => ENV["pingpp_app_id"]}}.merge(pay_orders))
    update(charge_id: charge.id)
    return charge
  end


  #退款
  def pingpp_refund(options={})
    options = {amount: (self.price * 100).to_i, description: self.reason}.merge(options)
    charge = pingpp_charge_type
    charge.refunds.create(options)
  end


    #查询一个订单的退款
  def pingpp_charge_refund(options={})
    options = {limit: 10, starting_after: nil, ending_before: nil}.merge(options).compact
    pingpp_charge_type.refunds.all(options)
  end

  #查询一个交易状态
  def pingpp_charge_type
    Pingpp::Charge.retrieve(self.charge_id)
  end

  #查询一个退款
  def pingpp_query_refund
    pingpp_charge_type.refunds.retrieve(self.refund_id)
  end

end
