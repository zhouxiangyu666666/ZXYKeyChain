
Pod::Spec.new do |s|


  s.name         = "ZXYKeyChain"
  s.version      = "1.0"
  s.summary      = "ZXYKeyChain is a convenient tool class for operationing keychain"

  s.description  = "ZXYKeyChain是操作keychain的一个工具类，非常方便的实现往钥匙链中存储等操作,其中提供了增删改查的方法。在KeychainWrapper的基础上做了封装，用了一个单例类ZXYUserManager来对Keychain操作 提供了一个ZXYUserManager.h类，和ZXYKeyChain.a的静态库。"

  s.homepage     = "https://github.com/zhouxiangyu666666/ZXYKeyChain"


  s.license      = "MIT"
  s.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  s.author             = { "zhouxiangyu" => "1242347457@qq.com" }

  s.source       = { :git => "https://github.com/zhouxiangyu666666/ZXYKeyChain.git", :tag => "#{s.version}" }

  s.source_files  = "ZXYKeyChain/*"

end
