class MainController < ApplicationController
  def index

  end

def permutate(first_name, last_name, domain)
first_initial = first_name[0]
last_initial = last_name[0]

  # Define each name permutation manually
name_permutations = <<PERMS
{first_name}
{last_name}
{first_initial}
{last_initial}
{first_name}{last_name}
{first_name}.{last_name}
{first_initial}{last_name}
{first_initial}.{last_name}
{first_name}{last_initial}
{first_name}.{last_initial}
{first_initial}{last_initial}
{first_initial}.{last_initial}
{last_name}{first_name}
{last_name}.{first_name}
{last_name}{first_initial}
{last_name}.{first_initial}
{last_initial}{first_name}
{last_initial}.{first_name}
{last_initial}{first_initial}
{last_initial}.{first_initial}
{first_name}-{last_name}
{first_initial}-{last_name}
{first_name}-{last_initial}
{first_initial}-{last_initial}
{last_name}-{first_name}
{last_name}-{first_initial}
{last_initial}-{first_name}
{last_initial}-{first_initial}
{first_name}_{last_name}
{first_initial}_{last_name}
{first_name}_{last_initial}
{first_initial}_{last_initial}
{last_name}_{first_name}
{last_name}_{first_initial}
{last_initial}_{first_name}
{last_initial}_{first_initial}
PERMS

  # substitutions to get all permutations to an Array
  name_permutations = name_permutations.gsub('{first_name}', first_name)
                                       .gsub('{last_name}', last_name)
                                       .gsub('{first_initial}', first_initial)
                                       .gsub('{last_initial}', last_initial)
                                       .split($/)

  # accept domain arg to be a string or an array
  # %40 => @
  if domain.is_a? String
    domain = ['%40'].product domain.split
  elsif domain.is_a? Array
    domain = ['%40'].product domain
  else
    raise ArgumentError, 'Domain was neither a String or Array'
  end

  name_and_domains = name_permutations.product domain

  # combine names and domains
  # return permuations
  @permutations = name_and_domains.map {|email| email.join }
end

def finder
  require 'email_check.rb'
  require 'uri'
  fname = (params[:fname]).downcase
  lname = (params[:lname]).downcase
  url = (params[:url]).downcase

  @emails = permutate(fname, lname, url)

  email_list = []

  @emails.each do |email|
    checker = EmailCheck.run(URI.decode(email),"no-reply@#{url}", url).valid?
      if checker
        email_list += [URI.decode(email)]
        @email = email_list.join(', ')
      end
  end
end
end
