module Sevendigital
  class ProxyPolice

    def ProxyPolice.ensure_is_proxy(xml_or_proxy, element_name)
      if xml_or_proxy.kind_of? Peachy::Proxy then
          return xml_or_proxy
      else
          return ProxyPolice.create_release_proxy(xml_or_proxy, element_name)
      end
    end

    def ProxyPolice.create_release_proxy(xml, element_name)
      #TODO don't use eval
      parent_proxy = Peachy::Proxy.new(xml)
      if element_name
#        parent_proxy.send(element_name)
        eval "parent_proxy.#{element_name.to_s}"
      else
        parent_proxy
      end
    end

  end
end