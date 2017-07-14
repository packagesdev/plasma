/*
 * Copyright (C) 2002  Terence M. Welsh
 *
 * Plasma is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as 
 * published by the Free Software Foundation.
 *
 * Plasma is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */


// Plasma screen saver

#ifdef WIN32
#include <rsWin32Saver/rsWin32Saver.h>
#include <resource.h>
#include <regstr.h>
#include <commctrl.h>
#endif

#include "Plasma.h"
#include <OpenGL/gl.h>
#include <OpenGL/glu.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

#define PIx2 6.28318530718f

// useful random functions

static float myRandf(float x)
{
    return(((double) rand() * x) / RAND_MAX);
}


// Find absolute value and truncate to 1.0

static float fabstrunc(float f)
{
    if(f >= 0.0f)
        return((f <= 1.0f) ? f : 1.0f);
    else
        return((f >= -1.0f) ? -f : 1.0f);
}

scene::scene()
{
	srand((unsigned)time(NULL));
	rand(); rand(); rand(); rand(); rand();
	rand(); rand(); rand(); rand(); rand();
	rand(); rand(); rand(); rand(); rand();
	rand(); rand(); rand(); rand(); rand();
}

scene::~scene()
{
	GLuint texnum=1;
	
	glBindTexture(GL_TEXTURE_2D, 0);
	glDeleteTextures(1,&texnum);
	
	glDisable(GL_TEXTURE_2D);
	
	if (plasmamap!=NULL)
	{
		delete[] plasmamap;
		plasmamap=NULL;
	}
	
	if (plasma!=NULL)
	{
		for(int i=0; i<plasmasize; i++)
		{
			int maxj=(int) (plasmasize / aspectRatio);
			
			for(int j=0; j<maxj; j++)
			{
				delete[] plasma[i][j];
				delete[] position[i][j];
			}
			
			delete[] plasma[i];
			delete[] position[i];
		}
		
		delete[] plasma;
		delete[] position;
		
		plasma=NULL;
		position=NULL;
	}
}

#pragma mark -

void scene::resize(int inWidth,int inHeight)
{
	// Window initialization
	
	glViewport(0,0, inWidth,inHeight);
	aspectRatio = ((float)inWidth) / ((float)inHeight);
	
	if(aspectRatio >= 1.0f)
	{
		wide = 30.0f / zoom;
		high = wide / aspectRatio;
	}
	else
	{
		high = 30.0f / zoom;
		wide = high * aspectRatio;
	}
	
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	gluOrtho2D(0.0f, 1.0f, 0.0f, 1.0f);
	
	glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
	glClear(GL_COLOR_BUFFER_BIT);
}

void scene::create()
{
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	
	// Set resolution of plasma
	
	if(aspectRatio >= 1.0f)
		plasmasize = (resolution * MAXTEXSIZE) / 100;
	else
		plasmasize = (int)(((float)resolution * MAXTEXSIZE) * aspectRatio * 0.01f);
	
	// Set resolution of texture
	
	texsize = 16;
	if(aspectRatio >= 1.0f)
	{
		while(plasmasize > texsize)
			texsize *= 2;
	}
	else
	{
		while(int(((float) plasmasize) / aspectRatio) > texsize)
			texsize *= 2;
	}
	
	// Initialize memory and positions
	
	plasmamap = new float[texsize*texsize*3];
	
	for(int i=0; i<texsize*texsize*3; i++)
	{
		plasmamap[i] = 0.0f;
	}
	
	plasma = new float**[plasmasize];
	position = new float**[plasmasize];
	
	for(int i=0; i<plasmasize; i++)
	{
		int maxj=(int)(((float)plasmasize) / aspectRatio);
		
		plasma[i] = new float*[maxj];
		position[i] = new float*[maxj];
		
		for(int j=0; j<maxj; j++)
		{
			plasma[i][j] = new float[3];
			position[i][j] = new float[2];
			
			plasma[i][j][0] = 0.0f;
			plasma[i][j][1] = 0.0f;
			plasma[i][j][2] = 0.0f;
			
			position[i][j][0] = (((float) i) * wide) / (((float)plasmasize) - 1) - (wide * 0.5f);
			position[i][j][1] = (((float) j) * high) / ((((float)plasmasize)) / aspectRatio - 1.0f) - (high * 0.5f);
		}
	}
	
	// Initialize constants
	
	for(int i=0; i<NUMCONSTS; i++)
	{
		ct[i] = myRandf(PIx2);
		cv[i] = myRandf(0.005f * ((float) speed)) + 0.0001f;
	}
	
	// Make texture
	
	glBindTexture(GL_TEXTURE_2D, 1);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP);
	
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, texsize, texsize, 0,GL_RGB, GL_FLOAT, plasmamap);
	glEnable(GL_TEXTURE_2D);
	glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_DECAL);
}

void scene::draw()
{
    float focus = ((float) this->focus)/ 50.0f + 0.3f;
	
    // Update constants
	
    for(int i=0; i<NUMCONSTS; i++)
    {
        ct[i] += cv[i];
		
        if(ct[i] > PIx2)
            ct[i] -= PIx2;
		
        c[i] = ((float) sin((double)ct[i])) * focus;
    }

    // Update colors
	
    int maxj=(int)(((float)plasmasize) / aspectRatio);
    float maxdiff = 0.004f * (float) (speed);
	
    for(int i=0; i<plasmasize; i++)
    {
        for(int j=0; j<maxj; j++)
        {
            float rgb[3];
			
			// Calculate vertex colors
	
            rgb[0] = plasma[i][j][0];
            rgb[1] = plasma[i][j][1];
            rgb[2] = plasma[i][j][2];
			
            float * tPosition=position[i][j];
            
            plasma[i][j][0] = 0.7f* (c[0] * tPosition[0] + c[1] * tPosition[1]
                                   + c[2] * (tPosition[0] * tPosition[0] + 1.0f)
                                   + c[3] * tPosition[0] * tPosition[1]
                                   + c[4] * rgb[1] + c[5] * rgb[2]);
                                   
            plasma[i][j][1] = 0.7f* (c[6] * tPosition[0] + c[7] * tPosition[1]
                                   + c[8] * tPosition[0] * tPosition[0]
                                   + c[9] * (tPosition[1] * tPosition[1] - 1.0f)
                                   + c[10] * rgb[0] + c[11] * rgb[2]);
                                   
            plasma[i][j][2] = 0.7f* (c[12] * tPosition[0] + c[13] * tPosition[1]
				   + c[14] * (1.0f - tPosition[0] * tPosition[1])
                                   + c[15] * tPosition[1] * tPosition[1]
                                   + c[16] * rgb[0] + c[17] * rgb[1]);

            // Don't let the colors change too much
            
            float temp = plasma[i][j][0] - rgb[0];
            
            if(temp > maxdiff)
                plasma[i][j][0] = rgb[0] + maxdiff;
            else
            {
                if(temp < -maxdiff)
                    plasma[i][j][0] = rgb[0] - maxdiff;
            }
            
            temp = plasma[i][j][1] - rgb[1];
            
            if(temp > maxdiff)
                plasma[i][j][1] = rgb[1] + maxdiff;
            else
            {
                if(temp < -maxdiff)
                    plasma[i][j][1] = rgb[1] - maxdiff;
            }
            
            temp = plasma[i][j][2] - rgb[2];
            
            if(temp > maxdiff)
                plasma[i][j][2] = rgb[2] + maxdiff;
            else
            {
                if(temp < -maxdiff)
                    plasma[i][j][2] = rgb[2] - maxdiff;
            }
            
            // Put colors into texture
			
            int index = (i * texsize + j) * 3;
			plasmamap[index] = fabstrunc(plasma[i][j][0]);
			plasmamap[index+1] = fabstrunc(plasma[i][j][1]);
			plasmamap[index+2] = fabstrunc(plasma[i][j][2]);
        }
    }

    // Update texture
    
    glPixelStorei(GL_UNPACK_ROW_LENGTH, texsize);
    glBindTexture(GL_TEXTURE_2D, 1);
        
    glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, (int)(((float)plasmasize) / aspectRatio), plasmasize,
		GL_RGB, GL_FLOAT, plasmamap);

	// Draw it
	// The "- 1" cuts off right and top edges to get rid of blending to black
	
    float texright = (((float)plasmasize) - 1) / ((float)texsize);
    float textop = texright / aspectRatio;
    
    glBegin(GL_TRIANGLE_STRIP);
            glTexCoord2f(0.0f, 0.0f);
            glVertex2f(0.0f, 0.0f);
            glTexCoord2f(0.0f, texright);
            glVertex2f(1.0f, 0.0f);
            glTexCoord2f(textop, 0.0f);
            glVertex2f(0.0f, 1.0f);
            glTexCoord2f(textop, texright);
            glVertex2f(1.0f, 1.0f);
    glEnd();
	
	glFinish();
}
