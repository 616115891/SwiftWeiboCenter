Pod::Spec.new do |s|
  s.name         = "SwiftWeiboCenter"
  s.version      = "0.0.1"
  s.authors      = {"yejinyong" => "616115891@qq.com"}
  s.summary      = "A short description of SwiftWeiboCenter."
  s.homepage     = "https://github.com/616115891/SwiftWeiboCenter.git"
  s.license      = "MIT (example)"
  s.source       = { :git => "https://github.com/616115891/SwiftWeiboCenter.git", :tag => "#{s.version}" }
  s.source_files  = "SwiftWeiboCenter", "SwiftWeiboCenter/**/*.{h,m}"
  s.license       = { :type => "MIT", :file => "LICENSE" }
end
