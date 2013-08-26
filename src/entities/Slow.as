package entities {
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Mask;

	public class Slow extends Entity{
		
		public function Slow(x:Number, y:Number, graphic:Image, mask:Mask) {
			type = "slow";
			super(x, y, graphic, mask);
		}
		
		public function destroy() : void {
		}
		
	}

}