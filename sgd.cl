__kernel
void compute_kernel (__global const int* idx,
		     __global const float* x,
                     __global const float* w,
                     __global float* res,
                     int dim)
{
  int j = get_global_id(0);
  int id = idx[j];

  float r = 0.f;
  for (int i=0; i<dim; ++i)
    r += w[i]*x[id*dim + i];
  res[j] = r;
}

__kernel
void decision_function (__global const float* x,
                        __global const float* w,
                        __global float* res,
                        int dim)
{
  int id = get_global_id(0);
  float r = 0.f;
  for (int i=0; i<dim; ++i)
    r += w[i]*x[id*dim + i];
  res[id] = r;
}

__kernel
void update_weights (__global const int* idx,
                     __global const float* x,
                     __global const float* y,
                     __global float* w,
                     int dim,
                     float etat,
                     float lambda,
                     int n_candidates)
{
  int i = get_global_id(0);

  float subgr = 0.f;
  for (int j=0; j<n_candidates; ++j)
  {
    int id = idx[j];
    subgr += y[id]*x[id*dim + i];
  }

  w[i] = (1.f - etat*lambda)*w[i] + etat/((float)n_candidates)*subgr;
}

__kernel
void compute_l2norm (__global const float* w,
                     __global float* ret,
                     int dim)
{
  float r = 0.f;
  for (int i=0; i<dim; ++i)
    r += w[i]*w[i];
  ret[0] = sqrt(r);
}

__kernel
void projectOntoL2Ball (__global float* w,
                       float norm)
{
  w[get_global_id(0)] /= norm;
}
