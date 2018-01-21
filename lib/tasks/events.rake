namespace :events do
  desc "TODO"
  task delete: :environment do
  	EventResult.delete_all
  end

end
