#ifndef FAIR_CLASSIFIER_H
#define FAIR_CLASSIFIER_H

#include "Vector.h"
#include "Matrix.h"
#include "boost/multi_array.hpp"

class FairClassifier
{
public:
	class Model
	{
	public:
		int n_X;
		int n_Y;
		int n_Z;

		boost::multi_array<real, 3> delta(int x, int y, int z);
		boost::multi_array<real, 3> Pxyz;
		boost::multi_array<real, 3> Px_yz;
		boost::multi_array<real, 3> Pz_xy;
		
		Matrix Pxyz(int x, int y, int z);
		Matrix Px_yz(int x, int y, int z);
		Matrix Pz_xy(int z, int x, int y);
		Matrix Pz_y(int z, int y);
		Matrix Pyz(int y, int z);
		Matrix Pxy(int x, int y);
		Matrix Px_y(int x, int y);
		Matrix Py_x(int x, int y);
		Vector Px(int x);
		Vector Py(int y);
		Vector Pz(int z);


		void CalculateMarginals()
		{
			for (int x=0; x<n_X; ++x) {
				Px(x) = 0;
				for (int y=0; y<n_Y; ++y) {
					for (int z=0; z<n_Z; ++z) {
						Px(x) += Pxyz(x,y,z);
					}
				}
			}

			for (int y=0; y<n_Y; ++y) {
				Py(y) = 0;
				for (int x=0; x<n_X; ++x) {
					for (int z=0; z<n_Z; ++z) {
						Py(y) += Pxyz(x,y,z);
					}
				}
			}

			for (int z=0; z<n_Z; ++z) {
				Pz(z) = 0;
				for (int x=0; x<n_X; ++x) {
					for (int y=0; y<n_Y; ++y) {
						Pz(z) += Pxyz(x,y,z);
					}
				}
			}

			
			
		}
		
			
	};
	Matrix UtilityGradient(Policy& policy, Model& model, Matrix& U);
	Matrix FairnessGradient() const;
	real Fairness() const;
};
