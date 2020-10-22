--@name CRT Aesthetics 2
--@author Neatro
--@shared

--################################
--#                              #
--#  CRT Aesthetics 2 by Neatro  #
--#                              #
--################################
-- do not claim as your own please
--   Licenced under BSD 3-Clause

if CLIENT then
    
    CRT = {} --namespace
    
    CRT.RES = 128 --CRT resolution, baked
    CRT.PixelOutLine = 64 --the space between pixels
    CRT.SDepth = 64 --how deep shall the screen bend inwards?
    CRT.SPop = 0 --how much shall the screen's center pop out from the SF screen?
    CRT.MeshResolution = 16 --how many segments across shall the CRT mesh be made of?
    
    --dont touch the rest
    CRT.White = render.createMaterial("holograms/hologram")
    CRT.overlay = "CRToverlay"
    CRT.Cols = { Color( 255, 0, 0, 255 ), Color( 0, 255, 0, 255 ), Color( 0, 0, 255, 255 ) }
    CRT.ColW = Color( 255, 255, 255, 255 )
    render.createRenderTarget( CRT.overlay )
    
    CRT.OverlayMat = material.create("Modulate_DX9")
    CRT.OverlayMat:setTextureRenderTarget( "$basetexture", CRT.overlay )
    
    CRT.Font = render.createFont("Courier New", 16, 400, false, false, false, false, false, false)
    
    local Meshsize = CRT.MeshResolution 
    local Dist = 512 / ( Meshsize - 1 )
    local DistN = 1 / ( Meshsize - 1 ) / ( 1024 / CRT.RES )
    local DistNx = 1 / ( Meshsize - 1 ) * CRT.RES
    
    local ScreenMeshPoints = {} 
    local ScreenMesh = {} 
    local OverlayScreenMesh = {}
    
    local Biggest = ( 1 - ( Meshsize / 2 + 0.5 ) ) ^ 2 + ( 1 - ( Meshsize / 2 + 0.5 ) ) ^ 2 --highest point
    
    for X = 1, Meshsize do
        for Y = 1, Meshsize do
            ScreenMeshPoints[ X .. "," .. Y ] = ( ( X - ( Meshsize / 2 + 0.5 ) ) ^ 2 + ( Y - ( Meshsize / 2 + 0.5 ) ) ^ 2 ) / Biggest --calculate each point
        end
    end
    
    for X = 1, ( Meshsize - 1 ) do
        for Y = 1, ( Meshsize - 1 ) do
            table.insert( ScreenMesh, { pos = Vector( ( X - 1 ) * Dist, ( Y - 1 ) * Dist, ScreenMeshPoints[ ( X ) .. "," .. ( Y ) ] * CRT.SDepth - CRT.SPop ), u = ( X - 1 ) * DistN, v = ( Y - 1 ) * DistN } )
            table.insert( ScreenMesh, { pos = Vector( ( X ) * Dist, ( Y - 1 ) * Dist, ScreenMeshPoints[ ( X + 1 ) .. "," .. ( Y ) ] * CRT.SDepth - CRT.SPop ), u = ( X ) * DistN, v = ( Y - 1 ) * DistN } )
            table.insert( ScreenMesh, { pos = Vector( ( X - 1 ) * Dist, ( Y ) * Dist, ScreenMeshPoints[ ( X ) .. "," .. ( Y + 1 ) ] * CRT.SDepth - CRT.SPop ), u = ( X - 1 ) * DistN, v = ( Y ) * DistN } )
            table.insert( ScreenMesh, { pos = Vector( ( X - 1 ) * Dist, ( Y ) * Dist, ScreenMeshPoints[ ( X ) .. "," .. ( Y + 1 ) ] * CRT.SDepth - CRT.SPop ), u = ( X - 1 ) * DistN, v = ( Y ) * DistN } )
            table.insert( ScreenMesh, { pos = Vector( ( X ) * Dist, ( Y - 1 ) * Dist, ScreenMeshPoints[ ( X + 1 ) .. "," .. ( Y ) ] * CRT.SDepth - CRT.SPop ), u = ( X ) * DistN, v = ( Y - 1 ) * DistN } )
            table.insert( ScreenMesh, { pos = Vector( ( X ) * Dist, ( Y ) * Dist, ScreenMeshPoints[ ( X + 1 ) .. "," .. ( Y + 1) ] * CRT.SDepth - CRT.SPop ), u = ( X ) * DistN, v = ( Y ) * DistN } )
        end
    end
    
    for X = 1, ( Meshsize - 1 ) do
        for Y = 1, ( Meshsize - 1 ) do
            table.insert( OverlayScreenMesh, { pos = Vector( ( X - 1 ) * Dist, ( Y - 1 ) * Dist, ScreenMeshPoints[ ( X ) .. "," .. ( Y ) ] * CRT.SDepth - CRT.SPop ), u = ( X - 1 ) * DistNx, v = ( Y - 1 ) * DistNx } )
            table.insert( OverlayScreenMesh, { pos = Vector( ( X ) * Dist, ( Y - 1 ) * Dist, ScreenMeshPoints[ ( X + 1 ) .. "," .. ( Y ) ] * CRT.SDepth - CRT.SPop ), u = ( X ) * DistNx, v = ( Y - 1 ) * DistNx } )
            table.insert( OverlayScreenMesh, { pos = Vector( ( X - 1 ) * Dist, ( Y ) * Dist, ScreenMeshPoints[ ( X ) .. "," .. ( Y + 1 ) ] * CRT.SDepth - CRT.SPop ), u = ( X - 1 ) * DistNx, v = ( Y ) * DistNx } )
            table.insert( OverlayScreenMesh, { pos = Vector( ( X - 1 ) * Dist, ( Y ) * Dist, ScreenMeshPoints[ ( X ) .. "," .. ( Y + 1 ) ] * CRT.SDepth - CRT.SPop ), u = ( X - 1 ) * DistNx, v = ( Y ) * DistNx } )
            table.insert( OverlayScreenMesh, { pos = Vector( ( X ) * Dist, ( Y - 1 ) * Dist, ScreenMeshPoints[ ( X + 1 ) .. "," .. ( Y ) ] * CRT.SDepth - CRT.SPop ), u = ( X ) * DistNx, v = ( Y - 1 ) * DistNx } )
            table.insert( OverlayScreenMesh, { pos = Vector( ( X ) * Dist, ( Y ) * Dist, ScreenMeshPoints[ ( X + 1 ) .. "," .. ( Y + 1) ] * CRT.SDepth - CRT.SPop ), u = ( X ) * DistNx, v = ( Y ) * DistNx } )
        end
    end
    
    CRT.Mesh = mesh.createFromTable( ScreenMesh )
    CRT.OverlayMesh = mesh.createFromTable( OverlayScreenMesh ) 
    
    --prepare overlay
    hook.add( "render", "CRT-pre", function() 
        if not shit then
            render.selectRenderTarget( CRT.overlay )
            render.setMaterial( CRT.White )
            for A = 0, 2 do
                render.setColor( CRT.Cols[ (A % 3) + 1 ] ) --CRT.Cols[ A % 3 ] )
                render.drawRectFast( math.ceil(1024/3)*A+CRT.PixelOutLine/2, 0+CRT.PixelOutLine/2, math.ceil(1024/3)-CRT.PixelOutLine, 1024-CRT.PixelOutLine )
            end
            render.selectRenderTarget()
            shit = true
            render.setBackgroundColor( Color( 0, 0, 0, 0 ) )
        end
        --render.setRenderTargetTexture( CRT.overlay )
        
        --render.drawTexturedRect( 0, 0, 512, 512 )
        --hook.remove( "render", "CRT-pre" )
    end )
          
    function CRT.create()
        local object = {}
        object.id = tostring( object )
        object.RT = "CRT"..object.id
        render.createRenderTarget( object.RT )
        
        function object:render( cb ) --draw what happens in the function
            self.drawfunc = cb
        end
        
        hook.add( "render", "CRT"..object.id, function() 
            render.setFilterMag( 3 )
            render.setFilterMin( 3 )
            object:select()
            if object.drawfunc then
                object.drawfunc()
            else
                render.setColor( Color( 0, 0, 255, 255 ) )
                render.drawRect( CRT.RES / 2 - 40, CRT.RES / 2 - 8, 80, 16 )
                
                render.setFont( CRT.Font )
                render.setColor( CRT.ColW )
                render.drawText( CRT.RES / 2, CRT.RES / 2 - 8, "NO SIGNAL", 1 )
            end
            object:deSelect()
            render.setColor( CRT.ColW )
            render.setRenderTargetTexture( object.RT )
            CRT.Mesh:draw()
            render.setMaterial( CRT.OverlayMat )
            CRT.OverlayMesh:draw()
        end )
        
        function object:select() --select this rendertarget
            render.selectRenderTarget( self.RT )
        end
        
        function object:deSelect() --deselect it
            render.selectRenderTarget( )
        end
        
        function object:destroy() --kill object, clean and free used resources
            hook.remove( "render", "CRT"..self.id )
            render.destroyRenderTarget( self.RT )
            self = nil
        end
        
        return object
    end
    
    -------------------------------------------------------------------------------------------------
    
    --how to use it
    MyCRT = CRT.create()
    ----[[
    MyCRT:render( function() 
        render.setFont( CRT.Font )
        render.setColor( CRT.ColW )
        render.drawText( CRT.RES / 2, CRT.RES / 2 - 8, "Neatro", 1 )
        --have fun
    end )
    --]]--
    --this will destroy the screen
    --MyCRT:destroy()


end
