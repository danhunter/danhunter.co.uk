module DanHunter
  class Site
    class Article
      attr_accessor :title, :body, :id, :created_at, :permalink, :published
      
      def initialize(meta, body, permalink)
        @title = meta[:title]
        @body = Haml::Engine.new(body).render
        @created_at = meta[:date]
        @published = meta[:published]
        
        @permalink = permalink
        @id = permalink.to_i
      end
      
      def path
        "/#{Article::article_dir}/#{permalink}"
      end
      
      def prev(published = true)
        article = Article.open_by_id(@id - 1)
        article if article && article.published = published
      end
    
      def next(published = true)
        article = Article.open_by_id(@id + 1)
        article if article && article.published = published
      end
      
      class << self
        attr_accessor :article_dir
        
        def latest
          published.first
        end
        
        def all
          articles = article_files.map { |filename| Article.open(filename) }
          puts ">>>"
          articles.each do |article| 
            puts article.title
          end
          articles.sort_by {|article| article.id}
          puts ">>>"
          articles.each do |article| 
            puts article.title
          end
          articles
        end
        
        def published
          all.select {|article| article && article.published }.reverse
        end
        
        def drafts
          all.select {|article| article && !article.published }.reverse
        end
        
        def article_files
          @article_files ||= (Dir.glob(File.join(article_dir, "*")))
        end
        
        def open_by_id(id)
          if match = Dir.glob(File.join(article_dir, "#{id}*"))
            Article.open(match.first) unless match.empty?
          end
        end
        
        def open(filename)
          article = false

          name << ".yml" if !(name =~ /.yml/)

          if File.exist?(filename)
            data = YAML.load_file(filename)
            permalink = to_permalink(File.basename(filename).gsub(/.yml/, ''))

            article = Article.new(data, data[:body], permalink)
          end
          
          article
        end
        
        def to_permalink(string, separator = "-", max_size = 127)
          
          permalink = string.gsub("'", "")

          permalink.downcase!

          permalink.gsub!(/[^a-z0-9]+/, separator)

          permalink = permalink.gsub(/^\\#{separator}+|\\#{separator}+$/, "")
          
          return permalink
          
        end
      end
      
      self.article_dir = "articles"
      
    end
  end
end