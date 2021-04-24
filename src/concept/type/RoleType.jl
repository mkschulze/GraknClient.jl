# This file is a part of GraknClient.  License is MIT: https://github.com/Humans-of-Julia/GraknClient.jl/blob/main/LICENSE

struct RoleType <: AbstractRoleType

    label::Label
    is_root::Bool
end

function RoleType(t::Proto._Type)
    return hasproperty(t, :scope) ?
        RoleType(Label(t.scope, t.label), t.root) :
        RoleType(Label(t.label), t.root)

# Porting note: Java client calls into RequstBuilder but it really
# has nothing to do with requests... I think it's probably better
# migrating the function here.
function proto(t::AbstractRoleType)
    Proto._Type(
        label = t.label.name,
        encoding = encoding(t)
    )
    # return RoleTypeRequestBuilder.proto_role_type(t.label, encoding(t))
end
