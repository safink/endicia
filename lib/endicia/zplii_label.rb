# This specialized ZPLII printer aims to provide a quick way to leverage
# the existing gem code to get a ZPL label without getting bogged down in
# fixing the overall gem.  When calling Endicia.get_label(ImageFormat: 'ZPLII')
# you'll get one of these back.  Pass :image to get the unpacked ZPLII text.
#
module Endicia
  class ZPLIILabel < Label
    attr_accessor :image, 
                  :status, 
                  :tracking_number, 
                  :final_postage, 
                  :transaction_date_time, 
                  :transaction_id, 
                  :postmark_date, 
                  :postage_balance, 
                  :pic,
                  :error_message,
                  :reference_id,
                  :cost_center,
                  :request_body,
                  :request_url,
                  :response_body
    def initialize(result)
      self.response_body = filter_response_body(result.body.dup)
      data        = result["LabelRequestResponse"] || {}
      encoded_zpl = data["Base64LabelImage"]
      @image      = Base64.decode64 encoded_zpl
    end
    
    private
    def filter_response_body(string)
      # Strip image data for readability:
      string.sub(/<Base64LabelImage>.+<\/Base64LabelImage>/,
                 "<Base64LabelImage>[data]</Base64LabelImage>")
    end
  end
end
