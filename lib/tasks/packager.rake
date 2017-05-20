require 'rubygems'
require 'zip'

@attributes = {
  "dc.contributor" => "contributor",
  "dc.contributor.advisor" => "advisor",
  "dc.contributor.author" => "creator",
  "dc.creator" => "creator",
  "dc.date" => "date_created",
  "dc.date.created" => "date_created",
  "dc.date.issued" => "date_issued",
  "dc.date.submitted" => "date_submitted",
  "dc.identifier" => "identifier",
  "dc.identifier.citation" => "bibliographic_citation",
  "dc.identifier.isbn" => "identifier",
  "dc.identifier.issn" => "identifier",
  "dc.identifier.other" => "identifier",
  "dc.identifier.uri" => "handle",
  "dc.description" => "description",
  "dc.description.abstract" => "abstract",
  "dc.description.provenance" => "provenance",
  "dc.description.sponsorship" => "sponsor",
  "dc.format.extent" => "extent",
  # "dc.format.medium" => "",
  "dc.language" => "language",
  "dc.language.iso" => "language",
  "dc.publisher" => "publisher",
  "dc.relation.ispartofseries" => "is_part_of",
  "dc.relation.uri" => "related_url",
  "dc.rights" => "rights_statement",
  "dc.subject" => "subject",
  "dc.subject.lcc" => "identifier",
  "dc.subject.lcsh" => "keyword",
  "dc.title" => "title",
  "dc.title.alternative" => "alternative_title",
  "dc.type" => "resource_type",
  "dc.type.genre" => "resource_type",
  "dc.date.updated" => "date_modified",
  "dc.contributor.sponsor" => "sponsor",
  "dc.description.embargoterms" => "embargo_terms",
  "dc.advisor" => "advisor",
  "dc.genre" => "resource_type",
  "dc.contributor.committeemember" => "committee_member",
  # dc.note" => "",
  "dc.rights.license" => "license",
  "dc.rights.usage" => "rights_statement",
  "dc.sponsor" => "sponsor"
}

@singulars = {
  "dc.date.available" => "date_uploaded", # Newspaper
  "dc.date.accessioned" => "date_accessioned", # Thesis
  "dc.date.embargountil" => "embargo_release_date", # Thesis
}

# embargo fields
# :visibility_during_embargo, :embargo_release_date, :visibility_after_embargo,
# :visibility_during_embargo: authenticated
# :visibility: embargo

# This is a variable to use during XML parse testing to avoid submitting new items
@debugging = FALSE

namespace :packager do

  task :aip, [:file, :user_id] =>  [:environment] do |t, args|
    puts "loading task import"

    @coverage = "" # for holding the current DSpace COMMUNITY name
    @sponsorship = "" # for holding the current DSpace CoLLECTIOn name

    @unmappedFields = File.open("/tmp/unmappedFields.txt", "w")

    @source_file = args[:file] or raise "No source input file provided."
    #@current_user = User.find_by_user_key(args[:user_id])

    @defaultDepositor = User.find_by_user_key(args[:user_id]) # THIS MAY BE UNNECESSARY

    # @uncapturedFields = Hash.new(0) # Hash.new {|h,k| h[k]=[]}

    puts "Building Import Package from AIP Export file: " + @source_file

    abort("Exiting packager: input file [" + @source_file + "] not found.") unless File.exists?(@source_file)

    @input_dir = File.dirname(@source_file)
    @output_dir = File.join(@input_dir, "unpacked") ## File.basename(@source_file,".zip"))
    Dir.mkdir @output_dir unless Dir.exist?(@output_dir)

    unzip_package(File.basename(@source_file))

    # puts @uncapturedFields
    @unmappedFields.close

  end
end

def unzip_package(zip_file,parentColl = nil)

  zpath = File.join(@input_dir, zip_file)

  if File.exist?(zpath)
    file_dir = File.join(@output_dir, File.basename(zpath, ".zip"))
    @bitstream_dir = file_dir
    Dir.mkdir file_dir unless Dir.exist?(file_dir)
    Zip::File.open(zpath) do |zipfile|
      zipfile.each do |f|
        fpath = File.join(file_dir, f.name)
        zipfile.extract(f,fpath) unless File.exist?(fpath)
      end
    end
    if File.exist?(File.join(file_dir, "mets.xml"))
      File.rename(zpath,@input_dir + "/complete/" + zip_file)
      return process_mets(File.join(file_dir,"mets.xml"),parentColl)
    else
      puts "No METS data found in package."
    end
  end

end

def process_mets (mets_file,parentColl = nil)

  children = Array.new
  files = Array.new
  uploadedFiles = Array.new
  depositor = ""
  type = ""
  params = Hash.new {|h,k| h[k]=[]}

  if File.exist?(mets_file)
    # xml_data = Nokogiri::XML.Reader(open(mets_file))
    dom = Nokogiri::XML(File.open(mets_file))

    current_type = dom.root.attr("TYPE")
    current_type.slice!("DSpace ")
    # puts "TYPE = " + current_type

    # puts dom.class
    # puts dom.xpath("//mets").attr("TYPE")

    data = dom.xpath("//dim:dim[@dspaceType='"+current_type+"']/dim:field", 'dim' => 'http://www.dspace.org/xmlns/dspace/dim')

    data.each do |element|
     field = element.attr('mdschema') + "." + element.attr('element')
     field = field + "." + element.attr('qualifier') unless element.attr('qualifier').nil?
     # puts field + " ==> " + element.inner_html

     # Due to duplication and ambiguity of output fields from DSpace
     # we need to do some very simplistic field validation and remapping
     case field
     when "dc.creator"
       if element.inner_html.match(/@/)
         # puts "Looking for User: " + element.inner_html
         depositor = getUser(element.inner_html) unless @debugging
         # depositor = @defaultDepositor
         # puts depositor
       end
     else
       # params[@attributes[field]] << element.inner_html.gsub "\r", "\n" if @attributes.has_key? field
       # params[@singulars[field]] = element.inner_html.gsub "\r", "\n" if @singulars.has_key? field
       params[@attributes[field]] << element.inner_html if @attributes.has_key? field
       params[@singulars[field]] = element.inner_html if @singulars.has_key? field
     end
     # @uncapturedFields[field] += 1 unless (@attributes.has_key? field || @singulars.has_key? field)
     @unmappedFields.write(field) unless @attributes.has_key? field
    end

    case dom.root.attr("TYPE")
    when "DSpace COMMUNITY"
      type = "admin_set"
      puts params
      @coverage = params["title"][0]
      puts "*** COMMUNITY ["+@coverage+"] ***"
      # puts params
    when "DSpace COLLECTION"
      type = "admin_set"
      @sponsorship = params["title"][0]
      puts "***** COLLECTION ["+@sponsorship+"] *****"
      # puts params
    when "DSpace ITEM"
      puts "******* ITEM ["+params["handle"][0]+"] *******"
      type = "work"
      # params["sponsorship"] << @sponsorship
      # params["coverage"] << @coverage
    end

    # if type == 'collection'
    if type == 'admin_set'
      structData = dom.xpath('//mets:mptr', 'mets' => 'http://www.loc.gov/METS/')
      structData.each do |fileData|
        case fileData.attr('LOCTYPE')
        when "URL"
          unzip_package(fileData.attr('xlink:href'))
          # puts coverage unless coverage.nil?
          # puts sponsorship unless sponsorship.nil?
        end
      end
    elsif type == 'work'
      # item = createItem(params,parentColl)

      fileMd5List = dom.xpath("//premis:object", 'premis' => 'http://www.loc.gov/standards/premis')
      fileMd5List.each do |fptr|
        fileChecksum = fptr.at_xpath("premis:objectCharacteristics/premis:fixity/premis:messageDigest", 'premis' => 'http://www.loc.gov/standards/premis').inner_html
        originalFileName = fptr.at_xpath("premis:originalName", 'premis' => 'http://www.loc.gov/standards/premis').inner_html
        # newFileName = dom.at_xpath("//mets:fileGrp[@USE='THUMBNAIL']/mets:file[@CHECKSUM='"+fileChecksum+"']/mets:FLocat/@xlink:href", 'mets' => 'http://www.loc.gov/METS/', 'xlink' => 'http://www.w3.org/1999/xlink').inner_html
        # puts newFileName

        ########################################################################################################################
        # This block seems incredibly messy and should be cleaned up or moved into some kind of method
        newFile = dom.at_xpath("//mets:file[@CHECKSUM='"+fileChecksum+"']/mets:FLocat", 'mets' => 'http://www.loc.gov/METS/')
        thumbnailId = nil
        case newFile.parent.parent.attr('USE') # grabbing parent.parent seems off, but it works.
        when "THUMBNAIL"
          newFileName = newFile.attr('xlink:href')
          puts newFileName + " -> " + originalFileName
          File.rename(@bitstream_dir + "/" + newFileName, @bitstream_dir + "/" + originalFileName)
          file = File.open(@bitstream_dir + "/" + originalFileName)

          sufiaFile = Hyrax::UploadedFile.create(file: file)
          sufiaFile.save
          # thumbnailId = sufiaFile.id

          uploadedFiles.push(sufiaFile)
          file.close
          ## params["thumbnail_id"] << sufiaFile.id
        when "TEXT"
        when "ORIGINAL"
          newFileName = newFile.attr('xlink:href')
          puts newFileName + " -> " + originalFileName
          File.rename(@bitstream_dir + "/" + newFileName, @bitstream_dir + "/" + originalFileName)
          file = File.open(@bitstream_dir + "/" + originalFileName)
          sufiaFile = Hyrax::UploadedFile.create(file: file)
          sufiaFile.save
          uploadedFiles.push(sufiaFile)
          file.close
        when "LICENSE"
          # Temp commented to deal with PDFs
          # newFileName = newFile.attr('xlink:href')
          # puts "license text: " + @bitstream_dir + "/" + newFileName
          # file = File.open(@bitstream_dir + "/" + newFileName, "rb")
          # params["rights_statement"] << file.read
          # file.close
        end
        # puts newFile.class
        # puts newFile.attr('xlink:href')
        # puts newFile.parent.parent.attr('USE')
        # File.rename(@bitstream_dir + "/" + newFileName, @bitstream_dir + "/" + originalFileName)
        # file = File.open(@bitstream_dir + "/" + originalFileName)
        # uploadedFiles.push(Sufia::UploadedFile.create(file: file))
        ########################################################################################################################

        # sleep(10) # Sleeping 10 seconds while the file upload completes for large files...

      end

      puts "-------- UpLoaded Files ----------"
      puts uploadedFiles
      puts "----------------------------------"

      puts "** Creating Item..."
      item = createItem(params,depositor) unless @debugging
      puts "** Attaching Files..."
      workFiles = AttachFilesToWorkJob.perform_now(item,uploadedFiles) unless @debugging
      # workFiles.save
      # puts workFiles
      # item.thumbnail_id = thumbnailId unless thumbnailId.nil?
      puts "Item id = " + item.id
      # item.save

      return item

    end
  end
end

def createCollection (params, parent = nil)
  coll = AdminSet.new(params)
#  coll = Collection.new(id: ActiveFedora::Noid::Service.new.mint)
#  params["visibility"] = "open"
#  coll.update(params)
#  coll.apply_depositor_metadata(@current_user.user_key)
  coll.save
#  return coll
end


def createItem (params, depositor, parent = nil)
  if depositor == ''
    depositor = @defaultDepositor
  end


  puts "Part of: #{params['part_of']}"

  id = ActiveFedora::Noid::Service.new.mint

  # Not liking this case statement but will refactor later.
  if params['resource_type'] == ["Thesis"]
    @work = Thesis.new(id: id)
  elsif params['resource_type'] == ["Dissertation"]
    @work = Dissertation.new(id: id)
  elsif params['resource_type'] == ["Project"]
    @work = Project.new(id: id)
  elsif params['resource_type'] == ["Newspaper"]
    @work = Newspaper.new(id: id)
  elsif params['resource_type'] == ["Article"]
    @work = Publication.new(id: id)
  elsif params['resource_type'] == ["Poster"]
    @work = Publication.new(id: id)
  elsif params['resource_type'] == ["Report"]
    @work = Publication.new(id: id)
  elsif params['resource_type'] == ["Preprint"]
    @work = Publication.new(id: id)
  elsif params['resource_type'] == ["Technical Report"]
    @work = Publication.new(id: id)
  elsif params['resource_type'] == ["Working Paper"]
    @work = Publication.new(id: id)
  elsif params['resource_type'] == ["painting"]
    @work = CreativeWork.new(id: id)
  elsif params['resource_type'] == ["ephemera"]
    @work = CreativeWork.new(id: id)
  elsif params['resource_type'] == ["textiles"]
    @work = CreativeWork.new(id: id)
  elsif params['resource_type'] == ["Empirical Research"]
    @work = CreativeWork.new(id: id)
  elsif params['resource_type'] == ["Award Materials"]
    @work = CreativeWork.new(id: id)
  elsif params['resource_type'] == ["photograph"]
    @work = CreativeWork.new(id: id)
  elsif params['resource_type'] == ["Mixed Media"]
    @work = CreativeWork.new(id: id)
  elsif params['resource_type'] == ["Other"]
    @work = CreativeWork.new(id: id)
  elsif params['resource_type'] == ["Creative Works"]
    @work = CreativeWork.new(id: id)
  else
    puts "Unknown type: #{params['resource_type']}"
  end

  # item = Thesis.new(id: ActiveFedora::Noid::Service.new.mint)
  # item = Newspaper.new(id: ActiveFedora::Noid::Service.new.mint)

  if params.key?("embargo_release_date")
    # params["visibility"] = "embargo"
    params["visibility_after_embargo"] = "open"
    params["visibility_during_embargo"] = "authenticated"
  else
    params["visibility"] = "open"
  end
  
  # add item to default admin set
  params["admin_set_id"] = AdminSet::DEFAULT_ID

  @work.update(params)
  @work.apply_depositor_metadata(depositor.user_key)
  @work.save
  return @work
end

def getUser(email)
  user = User.find_by_user_key(email)
  if user.nil?
    pw = (0...8).map { (65 + rand(52)).chr }.join
    puts "Created user " + email + " with password " + pw
    user = User.new(email: email, password: pw)
    user.save
  end
  # puts "returning user: " + user.email
  return user
end
