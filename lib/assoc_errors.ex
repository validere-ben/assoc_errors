defmodule AssocErrors do
  alias AssocErrors.User
  alias AssocErrors.Permission

  @doc """
  When using `put_assoc` with map inputs, invalid data is allowed to be inserted. The validations
  for the `Permissions` changeset are not respected when a map is provided as the assoc (as would
  have been had one used `cast_assoc`).

  When used with a changeset, the errors are respected as expected and the invalid data is not
  inserted.

  with_map:
  ```elixir
  # Changeset
  #Ecto.Changeset<
   action: nil,
   changes: %{
     email: "foo@example.com",
     permissions: [
       #Ecto.Changeset<
         action: :insert,
         changes: %{actions: ["invalid"], scope: "posts"},
         errors: [],
         data: #AssocErrors.Permission<>,
         valid?: true
       >
     ]
   },
   errors: [],
   data: #AssocErrors.User<>,
   valid?: true
  >

  # apply(changeset, :insert)
  {:ok,
  %AssocErrors.User{
   __meta__: #Ecto.Schema.Metadata<:built, "users">,
   email: "foo@example.com",
   id: nil,
   permissions: [
     %AssocErrors.Permission{
       __meta__: #Ecto.Schema.Metadata<:built, "permissions">,
       actions: ["invalid"],
       id: nil,
       scope: "posts",
       user: #Ecto.Association.NotLoaded<association :user is not loaded>,
       user_id: nil
     }
   ]
  }}

  # Insert result
  {:ok, %AssocErrors.User{
    __meta__: #Ecto.Schema.Metadata<:loaded, "users">,
    email: "foo@example.com",
    id: "161c69cb-fd65-45e6-97c0-5efc2348c530",
    permissions: [
      %AssocErrors.Permission{
        __meta__: #Ecto.Schema.Metadata<:loaded, "permissions">,
        actions: ["invalid"],
        id: "11d202a6-626d-4776-9bd1-078f7db8c498",
        scope: "posts",
        user: #Ecto.Association.NotLoaded<association :user is not loaded>,
        user_id: "161c69cb-fd65-45e6-97c0-5efc2348c530"
      }
    ]
  }
  ```

  with_changeset:
  ```elixir
  # Changeset
   #Ecto.Changeset<
   action: nil,
   changes: %{
     email: "bar@example.com",
     permissions: [
       #Ecto.Changeset<
         action: :insert,
         changes: %{actions: ["invalid"], scope: "posts"},
         errors: [
           actions: {"has an invalid entry",
            [validation: :subset, enum: ["create", "read", "update", "delete"]]}
         ],
         data: #AssocErrors.Permission<>,
         valid?: false
       >
     ]
   },
   errors: [],
   data: #AssocErrors.User<>,
   valid?: false
  >

  # apply(changeset, :insert)
  {:error,
  #Ecto.Changeset<
   action: :insert,
   changes: %{
     email: "bar@example.com",
     permissions: [
       #Ecto.Changeset<
         action: :insert,
         changes: %{actions: ["invalid"], scope: "posts"},
         errors: [
           actions: {"has an invalid entry",
            [validation: :subset, enum: ["create", "read", "update", "delete"]]}
         ],
         data: #AssocErrors.Permission<>,
         valid?: false
       >
     ]
   },
   errors: [],
   data: #AssocErrors.User<>,
   valid?: false
  >}

  # Insert result
  {:error, #Ecto.Changeset<
    action: :insert,
    changes: %{
      email: "bar@example.com",
      permissions: [
        #Ecto.Changeset<
          action: :insert,
          changes: %{actions: ["invalid"], scope: "posts"},
          errors: [
            actions: {"has an invalid entry",
             [validation: :subset, enum: ["create", "read", "update", "delete"]]}
          ],
          data: #AssocErrors.Permission<>,
          valid?: false
        >
      ]
    },
    errors: [],
    data: #AssocErrors.User<>,
    valid?: false
  >}

  with_struct:
  # Changeset
  #Ecto.Changeset<
   action: nil,
   changes: %{
     email: "baz@example.com",
     permissions: [
       #Ecto.Changeset<action: :insert, changes: %{}, errors: [],
        data: #AssocErrors.Permission<>, valid?: true>
     ]
   },
   errors: [],
   data: #AssocErrors.User<>,
   valid?: true
  >

  # apply_action(changeset, :insert)
  {:ok,
  %AssocErrors.User{
    __meta__: #Ecto.Schema.Metadata<:built, "users">,
    email: "baz@example.com",
    id: nil,
    permissions: [
      %AssocErrors.Permission{
        __meta__: #Ecto.Schema.Metadata<:built, "permissions">,
        actions: ["invalid"],
        id: nil,
        scope: "posts",
        user: #Ecto.Association.NotLoaded<association :user is not loaded>,
        user_id: nil
      }
    ]
  }}

  # Insert result
  {:ok,
  %AssocErrors.User{
   __meta__: #Ecto.Schema.Metadata<:loaded, "users">,
   email: "baz@example.com",
   id: "40d78fa5-1962-459a-acf7-a81fbd5a30a5",
   permissions: [
     %AssocErrors.Permission{
       __meta__: #Ecto.Schema.Metadata<:loaded, "permissions">,
       actions: ["invalid"],
       id: "50faab92-ba60-474b-ac59-143f25156bc1",
       scope: "posts",
       user: #Ecto.Association.NotLoaded<association :user is not loaded>,
       user_id: "40d78fa5-1962-459a-acf7-a81fbd5a30a5"
     }
   ]
  }}
  ```
  """
  def example do
    with_map =
      User.changeset(%User{}, %{
        email: "foo@example.com",
        permissions: [
          %{scope: "posts", actions: ["invalid"], user_id: nil}
        ]
      })

    with_changeset =
      User.changeset(%User{}, %{
        email: "bar@example.com",
        permissions: [
          Permission.changeset(%Permission{}, %{
            scope: "posts",
            actions: ["invalid"],
            user_id: nil
          })
        ]
      })

    with_struct =
      User.changeset(%User{}, %{
        email: "baz@example.com",
        permissions: [
          %Permission{scope: "posts", actions: ["invalid"], user_id: nil}
        ]
      })

    {with_map, with_changeset, with_struct}
  end
end
