::CarrierWave.configure do |config|
  config.storage             = :qiniu
  config.qiniu_access_key    = ENV['qiniu_ak']
  config.qiniu_secret_key    = ENV['qiniu_sk']
  config.qiniu_bucket        = 'keeper'
  config.qiniu_bucket_domain = ENV['qiniu_domain']
  config.qiniu_can_overwrite = true
  config.qiniu_block_size    = 4*1024*1024   
  config.qiniu_protocol      = "http"
  # config.qiniu_up_host       = "http://up.qiniug.com"  #选择不同的区域时，up.qiniug.com 不同
end