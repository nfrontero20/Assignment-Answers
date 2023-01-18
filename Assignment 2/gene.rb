require 'rest-client'
require 'json'
require './utils.rb'

class Gene
    attr_accessor :gene_id

    
    def initialize(params={})
      @gene_id = params.fetch(:id)
    end        
end