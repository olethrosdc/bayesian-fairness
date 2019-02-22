%% -*- Mode: octave -*-

function model = SampleDirichletModel(belief)
    model.X = belief.X;
    model.Y = belief.Y;
    model.Z = belief.Z;
    
    Px = dirichlet_rnd(belief.Nx);
    model.Pxyz = zeros(model.X, model.Y, model.Z);
    for x=1:model.X
        Py_x = dirichlet_rnd(belief.Ny_x(:,x));
        for y=1:model.Y
            Pz_yx = dirichlet_rnd(belief.Nz_yx(:,y,x));
            for z=1:model.Z
                model.Pxyz(x,y,z) = Pz_yx(z) * Py_x(y) * Px(x);
            end
        end
    end
    model = CalculateModelMarginals(model);
end
