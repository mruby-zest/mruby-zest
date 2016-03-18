class Osc
    attr_accessor :value, :metadata, :url
    attr_accessor :internalDb
    attr_accessor :externalDb
    def initialize(url)
        @value_prop
        @meta_prop
        @url = url
        @value = 0
        @internalDb = nil
        @externalDb = nil
    end

    def setValue(v)
        @value = v
        if(@internalDb)
            @internalDb.damage(@url)
        end
        if(@externalDb)
            @externalDb.damage(@url, value)
        end
    end
end

