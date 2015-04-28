#ifndef __PLASMA__
#define __PLASMA__

#define NUMCONSTS 18
#define MAXTEXSIZE 1024

class scene
{
	public:
	
		int zoom;
		int focus;
		int speed;
		int resolution;
	
		scene();
		virtual ~scene();
	
		void create();
		void resize(int inWidth,int inHeight);
		void draw();
	
	private:
	
		float aspectRatio;
		float wide;
		float high;
		float c[NUMCONSTS];  // constant
		float ct[NUMCONSTS];  // temporary value of constant
		float cv[NUMCONSTS];  // velocity of constant
		float ***position;
		float ***plasma;
		int texsize;
		int plasmasize;
		float *plasmamap;
};

#endif