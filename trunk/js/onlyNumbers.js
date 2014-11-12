
/* SOME SCRIPT TO ALLOW ONLY NUMBERS ON CERTAIN INPUTS, YOU ONLY NEED TO ADD THE CLASS "onlyNumbers" TO THAT INPUT */
(function($){
	$(document).ready(function(){
		
		var checkInput = function(evt, inputVal, decimal){
			var charCode = (evt.which) ? evt.which : event.keyCode;
	        
			/* Allow 1 "." */
			if(charCode == 46 && inputVal.split(".").length <= 1 && decimal.toUpperCase()=="SI"){ 
				return true;
			}
			
			/* Only numbers */
			if (charCode > 31 && (charCode < 48 || charCode > 57)){
	            return false;
	        }
			
	        return true;
		}
		
		var init = function(evt, $this){
			/* Default values */
			var decimal   = "si";
			
			if($this.data('allow-decimal') != undefined){
				decimal = $this.data('allow-decimal'); // true or false
			}
			
			return checkInput(evt, $this.val(), decimal);
		}
		
		$('.onlyNumbers').on('keypress' , function(evt){
			return init(evt, $(this));
		});
		
		$('.onlyNumbersContainer').on('keypress' , '.onlyNumbers', function(evt){
			return init(evt, $(this));
		});
		
		
		
		
		/* FOR MAX NUMBER */
		
		$('.onlyNumbers').on('keyup', function(evt){
			var $this = $(this);
			if($this.data('max-num')!=undefined){
				if( parseFloat($this.val()) > parseFloat($this.data('max-num')) ){// Que no permita poner valores mayores del que esta en data-max-number
					$this.val( $this.val().slice(0, $this.val().length-1) );	
				}
			}
		});
		
	});
})(jQuery);
