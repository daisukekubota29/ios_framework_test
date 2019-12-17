# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def install_rx_test
  pod 'RxBlocking', '~> 5'
  pod 'RxTest', '~> 5'
end

abstract_target 'All' do
  platform :ios, '10.0'
  use_frameworks!

  pod 'RxSwift', '~> 5'
  pod 'RxCocoa', '~> 5'
  pod 'RealmSwift', '4.1.1'

  target 'DomainLayer' do
    target 'DomainLayerTests' do
      inherit! :search_paths
      install_rx_test
    end
  end

  target 'DataLayer' do
    target 'DataLayerTests' do
      inherit! :search_paths
      install_rx_test
    end
  end

  target 'framework_test' do
    target 'framework_testTests' do
      inherit! :search_paths
      install_rx_test
    end
  end
end
