module GraphHelper

  def lineGraph(options = {})

    #records

    records = options[:records]
    
    raise "Graphable records must be of the same type, consider using a hash?" if records.map{|r| {:type => r.class}}.group_by{|t| t[:type]}.length > 1
    labelProc = options[:labelProc]

    #group records

    groupKey = options [:grouping]


    groups = records.group_by{|g| g[groupKey]}

    isXDate = false

    yParam = options[:y]
    xParam = options[:x]
    scale = options[:scale]
    xKeyProc = options[:xKeyProc]
    xtype = :numeric
    #if y is a DateTime assume we at a minimum want a scale of daily
    records.reject!{|r| r.send(xParam).nil? }

    if records.length > 0
      #check what our x key is?
      keyType = records[0].send(xParam).class

      if (keyType == ActiveSupport::TimeWithZone || keyType == DateTime || keyType == Date || keyType == Time)
        if scale.nil?
          scale = :daily
          xtype = :date
        end
      end


    else
      return "No data."
    end

    if (scale == :daily)
      xKeyProc = Proc.new{|x| x.strftime("%m/%d/%Y") }
    end
    

    #create a reduction hash for datasets

    #for each key in groups we will create a x and y dataset array


    

    groups.keys.each do |gk|
      curGroup = groups[gk]
      puts yParam
      if yParam == :_group_sum_for_x #special key where we group by x param for the y dataset
        #count the number of objects in this group for x key
        groups[gk] = curGroup.group_by{|g| xKeyProc.present? ? xKeyProc.call(g[xParam]) : g[xParam]} 
        groups[gk] = groups[gk].map{|k,v| {:"#{k}" => groups[gk][k].length} }
      end
    end

    labels = groups.keys.map{|x| labelProc.call(x)}
    xArrays = [] #dates
    yArrays = [] #poistions
    groups.each_pair do |k,v|
      xa = []
      ya = []
      merged = Hash[*v.map(&:to_a).flatten]
      puts "#{k} => #{merged.inspect}"
      merged.each_pair do |kk,vv|
        xa << kk.to_s
        ya << vv
      end
      xArrays << xa
      yArrays << ya

    end



    render :partial => "tmnt-graphs/partials/line_graph", :locals => {:xset => xArrays, :yset => yArrays, :labels => labels, :xtype => xtype, :legend => options[:legend]}
  end

  def barGraph

  end

  def pieGraph

  end

end