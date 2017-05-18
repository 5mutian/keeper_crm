class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
    	t.string :uuid
    	t.integer :width
    	t.integer :height
    	t.float :expected_square, default: 0.0 # 预计面积, CRM这边给
    	t.datetime :booking_date, null: false # 预约测量时间
    	t.float :rate
    	t.float :total
    	t.string :remark
    	t.string :state
    	t.string :courier_number # 单号
    	t.datetime :install_date # 预约安装时间
    	######### 窗管家 ############
    	t.integer :cgj_company_id # 品牌的 id
    	t.integer :cgj_customer_id # 客户的 id
    	t.integer :cgj_facilitator_id # 服务商id
    	t.integer :cgj_customer_service_id # 测量的人
    	######### 窗管家 ############
    	t.string :material # 材质
        t.integer :material_id # 材质_id
    	t.string :workflow_state # 状态[*]
    	t.boolean :public_order # 是否公开订单, 默认是不公开
    	t.float :square # 面积
    	t.boolean :mount_order # 是否直接就去安装的
    	t.string :serial_number # 订单序列号,根据品牌商来的
    	t.boolean :is_company # 是否是品牌上发布的单子
    	t.float :measure_amount # 测量费用
    	t.float :install_amount # 安装费用, 这个字段备用, 暂时使用 total
    	t.boolean :manager_confirm # 品牌商管理员是否已经确认
    	t.string :region, default: 'CRM' # 渠道, 来源
    	t.float :terminal_count # 服务费和安装费( 税前)
    	t.float :amount_total_count # 含税价, 服务和安装总价
    	t.integer :basic_order_tax # 税费, 平台服务费
    	t.integer :measure_amount_after_comment # 测量费(评论得分计算出)
    	t.integer :installed_amount_after_comment # 安装费(评论得分计算)
    	t.integer :measure_comment # 测量是否评论
    	t.float :measure_raty # 测量评分
    	t.float :installed_raty # 安装评分
    	t.float :service_measure_amount # 测量服务费, 测量劳务费
    	t.float :service_installed_amount # 安装劳务费
    	t.float :basic_tax # 平台服务费比率
    	t.float :deduct_installed_cost # 评价不好的被扣除的安装费
    	t.float :deduct_measure_cost # 评价不好被扣除的测量费
    	t.integer :sale_commission # 销售佣金
    	t.integer :intro_commission # 介绍人佣金
      t.string :remark

    	t.references :user, null: false # 属于某个saler
    	t.references :account, null: false
    	t.references :customer, null: false

      t.timestamps null: false
    end
  end
end
