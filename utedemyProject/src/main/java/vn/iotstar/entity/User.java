package vn.iotstar.entity;

import java.io.Serializable;
import java.sql.Date;
import java.util.HashSet;
import java.util.Set;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Inheritance;
import jakarta.persistence.InheritanceType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.JoinTable;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotEmpty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Data
@ToString(exclude = "roles")
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
@Table(name="users")
@Inheritance(strategy = InheritanceType.JOINED)
@NamedQuery(name="User.findAll", query="SELECT u from User u")
public class User implements Serializable {

	private static final long serialVersionUID = 1L;
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id")
	protected int id;
	
	@Column(name = "fullname", nullable = false, length = 200)
	@NotEmpty(message = "Không được phép rỗng")
	protected String fullname;
	
	@Column(name = "email")
	protected String email;
	
	@Column(name = "dateOfBirth")
	protected Date dateOfBirth;
	
	@Column(name = "gender")
	protected String gender;
	
	@Column(name = "phoneNumber")
	protected String phoneNumber;
	
	@Column(name = "address")
	protected String address;
	
	@Column(name = "avatarUrl", nullable = false, length = 200)
	@NotEmpty(message = "Không được phép rỗng")
	protected String avatarUrl;
	
	@Column(name = "password")
	protected String password;
	
	@ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(
        name = "user_roles",
        joinColumns = @JoinColumn(name = "user_id"),
        inverseJoinColumns = @JoinColumn(name = "role_id")
    )
	protected Set<Role> roles = new HashSet<>();
	
	public void addRole(Role role) {
        if (role != null && roles != null && !roles.contains(role)) {
            roles.add(role);
        }
    }
	
	@OneToMany(mappedBy = "createdBy", cascade = CascadeType.ALL)
    private Set<Review> review = new HashSet<>();
	
	@OneToOne(mappedBy = "user", cascade = CascadeType.ALL)
    private FavoriteCourse favoriteCourse;
	
	@OneToMany(mappedBy = "sender", cascade = CascadeType.ALL)
	private Set<Notification> sender = new HashSet<>();
	
	@OneToMany(mappedBy = "receiver", cascade = CascadeType.ALL)
	private Set<Notification> receiver = new HashSet<>();
	
	@OneToOne(mappedBy = "user", cascade = CascadeType.ALL)
    private Cart cart;
	
	@Column(name = "is_active")
    private Boolean isActive;
	
	@OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private Set<Orders> order  = new HashSet<>();
	
	@ManyToMany(mappedBy = "usedByUsers")
    private Set<Discount> usedDiscounts = new HashSet<>();
}