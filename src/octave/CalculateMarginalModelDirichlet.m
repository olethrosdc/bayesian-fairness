%% -*- Mode: octave -*-

function model = CalculateMarginalModelDirichlet(belief)
    model.X = belief.X;
    model.Y = belief.Y;
    model.Z = belief.Z;
    
    Px = belief.Nx / sum(belief.Nx);
    model.Pxyz = zeros(model.X, model.Y, model.Z);
    for x=1:model.X
        Py_x = belief.Ny_x(:,x) / sum(belief.Ny_x(:,x));
        for y=1:model.Y
            Pz_yx = belief.Nz_yx(:,y,x) / sum(belief.Nz_yx(:,y,x));
            for z=1:model.Z
                model.Pxyz(x,y,z) = Pz_yx(z) * Py_x(y) * Px(x);
            end
        end
    end
    model = CalculateModelMarginals(model);
end
