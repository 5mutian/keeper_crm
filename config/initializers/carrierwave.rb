::CarrierWave.configure do |config|
  config.storage             = :qiniu
  config.qiniu_access_key    = 'D2HoWxWkb2MHhZVO5J5902DyeGNA05csQJOomlg0'
  config.qiniu_secret_key    = 'TmrvwiSTzBO9snZ2dg8JOYuCQA19IetyN-gZpZT8'
  config.qiniu_bucket        = 'keeper'
  config.qiniu_bucket_domain = 'or2h31bsk.bkt.clouddn.com'
  config.qiniu_block_size    = 4*1024*1024   
  config.qiniu_protocol      = "http"  
  config.qiniu_up_host       = "http://up.qiniug.com"  #选择不同的区域时，up.qiniug.com 不同
end