## Rails Application Templates

### Quipper App

Script will look in your home directory for `.quipper`. Create it and set the following keys in YAML:

```
github_user: 'github_user:github_password'

database:
  test: quipper_test
  development: quipper_development
```

To use:

```
rails new my_new_app -m https://raw.github.com/osahyoun/rails-templates/master/quipper.rb -T -O
```