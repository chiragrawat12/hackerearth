class ImagesController < ApplicationController
    def index
        @pagy, @images = pagy(Image.all, items: 9)
    end

    def show
        @image = Image.find(params[:id])
    end

    def new
        @image = Image.new
    end

    def create
        image = Image.create(image_params)
        if image.save
            redirect_to image_path(image)
        end
    end

    def edit
        @image = Image.find(params[:id])
    end

    def update
        image = Image.find(params[:id])
        image.update(image_params)
        redirect_to image_path(image)
    end

    def destroy 
        image = Image.find(params[:id])
        if image
            image.image.purge_later
            image.destroy
        end
        redirect_to root_path, status: :see_other
    end

    def search
        # binding.pry
        @query = params[:query]
        if(@query != "")
            @pagy, @images = pagy(Image.where("images.name LIKE ?",["%#{@query}%"]), items: 9)
            render "index"
        end
    end

    private
        def image_params
            params.require(:image).permit(:name, :details, :image)
        end
end
