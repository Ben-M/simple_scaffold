#simple_scaffold
## What is this?
A rails template which sets some beginner friendly defaults and adds a generator for creating scaffolds that are easier to understand.
## Why?
Many tutorials aimed at beginners (for example the [Rails Girls App tutorial](http://guides.railsgirls.com/app/)) rely on Rails scaffolds. With recent releases of Rails the scaffolds have become better for experienced developers but less accessible to beginners; files unncessary for entry level tutorials are generated and the code in the controllers can be confusing.

The simple scaffold template generates scaffolds which are easier for beginners to understand.

## How do I use it?
Create a Rails app as you usually would, but add `-m` to tell Rails to download and use the simple_scaffold template:

`rails new myapp -m https://raw.github.com/Ben-M/simplescaffold/master/simplescaffold.rb`

When generating a scaffold use the simple_scaffold generator. Use it the same way you'd use the scaffold generator, but replace `scaffold` with `simple_scaffold`:

`rails generate simple_scaffold idea name:string description:text picture:string` 

## What is different?
### Settings
Generators will no longer generate:

- Tests
- Helpers
- Javascript/CoffeeScript files
- JBuilder files

*Note: you can turn generation of these files back on by editing the config.generators lines in application.rb*

### Controller
 - Records are loaded inline in the controller instead of using a `before_action`.
 - Controllers no longer include`respond_to` blocks.
 - Controller actions now explicitly call `render`.
 
## How can I help?
If you are helping beginners learn Rails then try using simple_scaffold and let us know how it goes. Feel free to add an issue with any suggestions.

If you'd like to improve the code then go ahead and send a pull request. If you'd like to discuss an idea before you start development then open an issue.